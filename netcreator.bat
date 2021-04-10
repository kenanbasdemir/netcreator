@echo off

mkdir %1
cd %1

REM CORE ##########################

dotnet new classlib -f netcoreapp3.1 -o %1.Core
cd %1.Core & del Class1.cs
mkdir Data & mkdir DataAccess & mkdir Utilities

dotnet add package MySql.EntityFrameworkCore --version 3.1.10
cd ..

REM DATA ##########################

dotnet new classlib -f netcoreapp3.1 -o %1.Data
cd %1.Data & del Class1.cs
mkdir Entities & mkdir Dtos & mkdir Utilities

dotnet add package MySql.EntityFrameworkCore --version 3.1.10
dotnet add package Microsoft.EntityFrameworkCore.Tools --version 3.1.10
cd ..

REM DATA-ACCESS ####################

dotnet new classlib -f netcoreapp3.1 -o %1.DataAccess
cd %1.DataAccess & del Class1.cs
mkdir Abstract & mkdir Concrete

dotnet add package Microsoft.EntityFrameworkCore --version 3.1.10
cd ..

REM WEB-API ########################

dotnet new webapi -f netcoreapp3.1 -o %1.WebAPI
cd %1.WebAPI

dotnet add package MySql.EntityFrameworkCore --version 3.1.10
cd ..

REM REFERENCES #####################

dotnet add %1.Data/%1.Data.csproj reference %1.Core/%1.Core.csproj
dotnet add %1.DataAccess reference %1.Data/%1.Data.csproj %1.Core/%1.Core.csproj
dotnet add %1.WebAPI reference %1.DataAccess %1.Data/%1.Data.csproj %1.Core/%1.Core.csproj

REM SOLUTION #######################

dotnet new sln --name %1
dotnet sln %1.sln add %1.Core %1.Data/%1.Data.csproj %1.DataAccess %1.WebAPI

cd ..

REM STARTUP #######################

start %1\%1.sln