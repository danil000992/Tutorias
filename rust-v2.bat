@echo off
chcp 65001 >nul 2>&1
title Instalador RustDesk Automatico

:: ==============================================
:: AUTO-ELEVACAO - Pede permissao de Administrador
:: ==============================================
net session >nul 2>&1
if %errorlevel% NEQ 0 (
    echo Solicitando permissao de Administrador...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

:: ==============================================
:: CONFIGURACOES
:: ==============================================
set "VERSAO=1.4.9"
set "SENHA_ACESSO=Aluno@123"
set "CONFIG_SERVIDOR="

:: ==============================================
:: INICIO
:: ==============================================
cls
echo ======================================
echo    Instalador RustDesk
echo ======================================
echo.
echo Executando como Administrador...
echo.

:: ==============================================
:: DESINSTALA VERSAO ANTIGA
:: ==============================================
set "RUSTDESK_ANTIGO=C:\Program Files\RustDesk\rustdesk.exe"

if exist "%RUSTDESK_ANTIGO%" (
    echo ======================================
    echo Desinstalando versao antiga...
    echo ======================================
    echo.

    "%RUSTDESK_ANTIGO%" --uninstall

    echo.

    if exist "%RUSTDESK_ANTIGO%" (
        echo.
        echo O executavel antigo ainda existe.
        timeout /t 5 /nobreak >nul
    )

    if exist "%RUSTDESK_ANTIGO%" (
        echo.
        echo ERRO: A versao antiga nao foi removida.
        echo.
        echo Verifique se o RustDesk ainda esta em execucao.
        pause
        exit /b 1
    )

    echo.
    echo Versao antiga removida com sucesso.
    echo.
) else (
    echo Nenhuma instalacao anterior encontrada.
    echo.
)

:: ==============================================
:: ESPERA ANTES DA NOVA INSTALACAO
:: ==============================================
::echo Aguardando 15 segundos antes de iniciar a nova instalacao...
::timeout /t 15 /nobreak >nul
::echo.
:: ==============================================
:: DOWNLOAD
:: ==============================================

set "PASTA_TEMP=%TEMP%\RustDeskInst"

if not exist "%PASTA_TEMP%" mkdir "%PASTA_TEMP%"

set "ARQUIVO_EXE=%PASTA_TEMP%\rustdesk.exe"

set "URL=https://github.com/rustdesk/rustdesk/releases/download/%VERSAO%/rustdesk-%VERSAO%-x86_64.exe"

echo.
echo Baixando RustDesk %VERSAO%...
echo.

curl -L "%URL%" -o "%ARQUIVO_EXE%"

if not exist "%ARQUIVO_EXE%" (
    echo.
    echo ERRO: Falha ao baixar o RustDesk.
    echo Verifique a conexao ou a versao informada.
    pause
    exit /b 1
)

echo.
echo Download concluido.
echo.

:: ==============================================
:: INSTALACAO
:: ==============================================
echo Instalando RustDesk %VERSAO%...
echo.

"%ARQUIVO_EXE%" --silent-install

timeout /t 15 /nobreak >nul

set "CAMINHO_INSTALADO=%ProgramFiles%\RustDesk\rustdesk.exe"

if not exist "%CAMINHO_INSTALADO%" (
    echo.
    echo ERRO: Instalacao falhou.
    echo Arquivo nao encontrado:
    echo %CAMINHO_INSTALADO%
    echo.
    pause
    exit /b 1
)

echo.
echo RustDesk instalado com sucesso.
echo.

:: ==============================================
:: INSTALA SERVICO
:: ==============================================
echo Registrando RustDesk como servico...
echo.

"%CAMINHO_INSTALADO%" --install-service

timeout /t 20 /nobreak >nul

echo Servico configurado.
echo.

:: ==============================================
:: CONFIGURA SENHA
:: ==============================================
::echo Configurando senha permanente...
::echo.

::"%CAMINHO_INSTALADO%" --password "%SENHA_ACESSO%"

::timeout /t 5 /nobreak >nul

::echo Senha definida.
::echo.

:: ==============================================
:: CONFIGURA SERVIDOR
:: ==============================================
if not "%CONFIG_SERVIDOR%"=="" (
    echo Aplicando configuracao do servidor...
    echo.

    "%CAMINHO_INSTALADO%" --config "%CONFIG_SERVIDOR%"

    timeout /t 5 /nobreak >nul

    echo Servidor configurado.
    echo.
)

:: ==============================================
:: OBTEM ID
:: ==============================================
echo Obtendo ID da maquina...

set "ID_RUSTDESK="

for /f "delims=" %%i in ('"%CAMINHO_INSTALADO%" --get-id') do set "ID_RUSTDESK=%%i"

timeout /t 3 /nobreak >nul

:: ==============================================
:: LIMPA TEMPORARIO
:: ==============================================
rd "%PASTA_TEMP%" /s /q 2>nul

:: ==============================================
:: RESULTADO
:: ==============================================
echo.
echo ======================================
echo INSTALACAO CONCLUIDA COM SUCESSO
echo ======================================
echo.
echo ID da maquina: %ID_RUSTDESK%
::echo Senha: %SENHA_ACESSO%
echo Servico: ATIVO
echo.
echo ======================================
echo.
echo Guarde o ID acima para acesso remoto.
timeout /t 10 /nobreak >nul
echo.
exit
