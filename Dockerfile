FROM microsoft/dotnet:2.2-aspnetcore-runtime AS base
WORKDIR /app
EXPOSE 80

FROM microsoft/dotnet:2.2-sdk AS build
WORKDIR /src

COPY ./AccountOwnerServer/AccountOwnerServer.csproj ./AccountOwnerServer/
COPY ./Contracts/Contracts.csproj ./Contracts/
COPY ./Repository/Repository.csproj ./Repository/
COPY ./Entities/Entities.csproj ./Entities/
COPY ./LoggerService/LoggerService.csproj ./LoggerService/
COPY ./Tests/Tests.csproj ./Tests/
COPY ./AccountOwnerServer.sln .

RUN dotnet restore

COPY . .

RUN dotnet build "./AccountOwnerServer/AccountOwnerServer.csproj" -c Release -o /app

RUN dotnet test "./Tests/Tests.csproj" -c Release

FROM build AS publish
RUN dotnet publish "./AccountOwnerServer/AccountOwnerServer.csproj" -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "AccountOwnerServer.dll"]