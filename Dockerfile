# Étape 1 : image d'exécution
FROM mcr.microsoft.com/dotnet/aspnet:10.0 AS base
WORKDIR /app
EXPOSE 8080
USER app

# Étape 2 : compilation
FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
WORKDIR /src

# Copier le fichier projet et restaurer les dépendances
COPY ["src/ProductCatalog.Api/ProductCatalog.Api.csproj", "ProductCatalog.Api/"]
RUN dotnet restore "ProductCatalog.Api/ProductCatalog.Api.csproj"

# Copier le code source
COPY src/ProductCatalog.Api/ ProductCatalog.Api/
WORKDIR /src/ProductCatalog.Api

# Compiler le projet
RUN dotnet build "ProductCatalog.Api.csproj" -c Release -o /app/build

# Étape 3 : publication
FROM build AS publish
RUN dotnet publish "ProductCatalog.Api.csproj" -c Release -o /app/publish /p:UseAppHost=false

# Étape 4 : image finale
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "ProductCatalog.Api.dll"]


