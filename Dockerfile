# Build stage
FROM mcr.microsoft.com/dotnet/sdk:2.1 AS build
WORKDIR /src

# Copy csproj and restore as distinct layers
COPY hello-world-api/hello-world-api.csproj hello-world-api/
RUN dotnet restore hello-world-api/hello-world-api.csproj

# Copy everything else and build
COPY hello-world-api/ hello-world-api/
WORKDIR /src/hello-world-api
RUN dotnet publish -c Release -o /app/out

# Runtime stage
FROM mcr.microsoft.com/dotnet/aspnet:2.1
WORKDIR /app
COPY --from=build /app/out .
EXPOSE 5000
ENTRYPOINT ["dotnet", "hello-world-api.dll"]
