FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS builder

ENV ASPNETCORE_URLS http://+:5000

WORKDIR /source

COPY Your.Namespace.sln .
COPY Your.Namespace/*.csproj ./Your.Namespace/
RUN dotnet restore

COPY Your.Namespace/. ./Your.Namespace/

RUN dotnet build --no-restore -c Release Your.Namespace/

RUN dotnet publish --no-build -c release -o /app Your.Namespace/

FROM mcr.microsoft.com/dotnet/core/aspnet:3.1 AS production

ENV USERNAME=appuser
ENV UID=1001
ENV GROUP=appgroup
ENV HOME=/home/${USERNAME}

RUN groupadd -r -g ${UID} ${GROUP} && \
    useradd -r -u ${UID} -g ${GROUP} -d ${HOME} -s /sbin/nologin -c "app user" ${USERNAME}
RUN mkdir -p ${HOME}/app && \
    chown -R ${USERNAME} ${HOME}

USER ${USERNAME}

WORKDIR ${HOME}/app

COPY --from=builder --chown=appuser:appgroup /app ./

EXPOSE 5000

ENTRYPOINT ["dotnet", "Your.Namespace.dll"]
