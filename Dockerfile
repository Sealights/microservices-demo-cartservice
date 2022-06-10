# Copyright 2021 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# https://mcr.microsoft.com/v2/dotnet/sdk/tags/list
FROM mcr.microsoft.com/dotnet/sdk:6.0.201 as base

ARG RM_DEV_SL_TOKEN=local
ENV RM_DEV_SL_TOKEN ${RM_DEV_SL_TOKEN}

FROM base as builder

WORKDIR /app/src
COPY src/cartservice.csproj .
RUN dotnet restore cartservice.csproj -r linux-musl-x64
COPY /src .
RUN dotnet publish cartservice.csproj -p:PublishSingleFile=true -r linux-musl-x64 --self-contained true -p:PublishTrimmed=True -p:TrimMode=Link -c release -o /cartservice --no-restore

WORKDIR /app/sealights
COPY sealights-dotnet-agent-3.0.1-beta.hotfix-portable.tar.gz .
RUN tar -xvzf sealights-dotnet-agent-3.0.1-beta.hotfix-portable.tar.gz
RUN rm sealights-dotnet-agent-3.0.1-beta.hotfix-portable.tar.gz

WORKDIR /app/tests
COPY ./tests/cartservice.tests.csproj .
RUN dotnet restore cartservice.tests.csproj -r linux-musl-x64
COPY ./tests .
RUN dotnet build

# https://mcr.microsoft.com/v2/dotnet/runtime-deps/tags/list
FROM mcr.microsoft.com/dotnet/sdk:6.0.201
RUN GRPC_HEALTH_PROBE_VERSION=v0.4.8 && \
    wget -qO/bin/grpc_health_probe https://github.com/grpc-ecosystem/grpc-health-probe/releases/download/${GRPC_HEALTH_PROBE_VERSION}/grpc_health_probe-linux-amd64 && \
    chmod +x /bin/grpc_health_probe
	
FROM base
	
WORKDIR /app

COPY --from=builder /cartservice .
COPY --from=builder /app/tests /app/tests
COPY --from=builder /app/sealights/sealights-dotnet-agent-3.0.1-beta.hotfix-portable /app

RUN dotnet SL.DotNet.dll config --token $RM_DEV_SL_TOKEN --appName cartservice --includedAssemblies "cartservice*" --branchName main --buildName $(date +%F_%T) --includeNamespace "cartservice.*" --excludeNamespace Microsoft
RUN dotnet SL.DotNet.dll scan --buildSessionIdFile /app/buildSessionId --binDir /app/tests/bin/Debug/net6.0 --token $RM_DEV_SL_TOKEN --ignoreGeneratedCode true
RUN dotnet SL.DotNet.dll startExecution --buildSessionIdFile buildSessionId --token $RM_DEV_SL_TOKEN --testStage "Unit test"
RUN dotnet SL.DotNet.dll testListener --buildSessionIdFile buildSessionId --token $RM_DEV_SL_TOKEN --workingDir /app/tests/bin/Debug/net6.0 --target dotnet --targetArgs " test cartservice.tests.dll " || true
RUN dotnet SL.DotNet.dll endExecution --buildSessionIdFile buildSessionId --token $RM_DEV_SL_TOKEN  --testStage "Unit test"

ENV ASPNETCORE_URLS http://*:7070
ENTRYPOINT ["/app/cartservice/cartservice"]
