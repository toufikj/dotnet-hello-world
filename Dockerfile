# Build Stage
FROM mcr.microsoft.com/dotnet/sdk:2.1 AS build
WORKDIR /src

COPY hello-world-api/*.csproj ./hello-world-api/
RUN dotnet restore ./hello-world-api/hello-world-api.csproj

COPY . .
RUN dotnet publish ./hello-world-api/hello-world-api.csproj -c Release -o /app/publish

# Runtime Stage
FROM mcr.microsoft.com/dotnet/aspnet:2.1 AS runtime
WORKDIR /app

# Make the app listen on port 5000 instead of 80
ENV ASPNETCORE_URLS=http://+:5000

EXPOSE 5000
COPY --from=build /app/publish .
ENTRYPOINT ["dotnet", "hello-world-api.dll"]
