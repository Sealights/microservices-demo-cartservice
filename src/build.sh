$ bash file
dotnet restore cartservice.csproj -r linux-musl-x64
dotnet build
dotnet publish cartservice.csproj -p:PublishSingleFile=true -r linux-musl-x64 --self-contained true -p:PublishTrimmed=True -p:TrimMode=Link -c release -o /cartservice --no-restore