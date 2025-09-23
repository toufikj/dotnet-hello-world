FROM mcr.microsoft.com/dotnet/sdk:2.1 AS build
WORKDIR /app
COPY hello-world-api.csproj ./
RUN dotnet restore
COPY . ./
RUN dotnet publish -c Release -o out

#2nd step

FROM mcr.microsoft.com/dotnet/aspnet:2.1
WORKDIR /app
COPY --from=build /app/out .
EXPOSE 5000
ENTRYPOINT ["dotnet", "hello-world-api.dll"]
