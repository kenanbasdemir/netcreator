 :: netcreator_NET.cmd myProject net7.0

@echo off

 :: -----------------------
SET filepath=%1
SET framework=%2
 :: -----------------------

IF "%filepath%" == "" set filePath=test
IF "%framework%" == "" set framework=net7.0

mkdir %filepath%
cd %filepath%

REM CORE ##########################

dotnet new classlib -f %framework% -o %filepath%.Core
cd %filepath%.Core & del Class1.cs
mkdir Data & mkdir DataAccess & mkdir Utilities

dotnet add package MySql.EntityFrameworkCore
cd ..

REM DATA ##########################

dotnet new classlib -f %framework% -o %filepath%.Data
cd %filepath%.Data & del Class1.cs
mkdir Entities & mkdir Dtos & mkdir Utilities

dotnet add package MySql.EntityFrameworkCore
dotnet add package Microsoft.EntityFrameworkCore.Tools
cd ..

REM DATA-ACCESS ####################

dotnet new classlib -f %framework% -o %filepath%.DataAccess
cd %filepath%.DataAccess & del Class1.cs
mkdir Abstract & mkdir Concrete

dotnet add package Microsoft.EntityFrameworkCore
cd ..

REM WEB-API ########################

dotnet new webapi -f %framework% -o %filepath%.WebAPI
cd %filepath%.WebAPI

dotnet add package MySql.EntityFrameworkCore
cd ..

REM REFERENCES #####################

dotnet add %filepath%.Data/%filepath%.Data.csproj reference %filepath%.Core/%filepath%.Core.csproj
dotnet add %filepath%.DataAccess reference %filepath%.Data/%filepath%.Data.csproj %filepath%.Core/%filepath%.Core.csproj
dotnet add %filepath%.WebAPI reference %filepath%.DataAccess %filepath%.Data/%filepath%.Data.csproj %filepath%.Core/%filepath%.Core.csproj

REM SOLUTION #######################

dotnet new sln --name %filepath%
dotnet sln %filepath%.sln add %filepath%.Core %filepath%.Data/%filepath%.Data.csproj %filepath%.DataAccess %filepath%.WebAPI

cd ..

REM STARTUP #######################

start %filepath%\%filepath%.sln
