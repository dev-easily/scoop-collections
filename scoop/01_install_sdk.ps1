chcp 65001
## c++
./install_cmd.ps1 mingw

## end c++

## rust
[Environment]::SetEnvironmentVariable('RUSTUP_DIST_SERVER', "https://rsproxy.cn", 'User')
$env:RUSTUP_DIST_SERVER = "https://rsproxy.cn"
[Environment]::SetEnvironmentVariable('RUSTUP_UPDATE_ROOT', "https://rsproxy.cn/rustup", 'User')
$env:RUSTUP_UPDATE_ROOT = "https://rsproxy.cn/rustup"

./install_cmd.ps1 rustup # or scoop si rustup

New-Item -Path $env:CARGO_HOME\config.toml -Type File -Force -Value(
@'
[source.crates-io]
replace-with = 'ustc'

[source.ustc]
registry = "sparse+https://mirrors.ustc.edu.cn/crates.io-index/"
'@
)
Invoke-WebRequest -Uri 'https://aka.ms/vs/17/release/vs_BuildTools.exe' -OutFile "$env:TEMP\vs_BuildTools.exe"

& "$env:TEMP\vs_BuildTools.exe" --passive --wait --add Microsoft.VisualStudio.Workload.VCTools --includeRecommended --remove Microsoft.VisualStudio.Component.VC.CMake.Project	

./install_cmd.ps1 cmake
cargo install crm
crm use ustc-sparse
## end rust

## node
./install_cmd.ps1 nodejs-lts
npm config set registry https://registry.npmmirror.com
npm install -g pnpm
pnpm setup
## pnpm config set global-bin-dir $env:PNPM_HOME\bin
[Environment]::SetEnvironmentVariable('ELECTRON_MIRROR', "https://npmmirror.com/mirrors/electron/", 'User')
[Environment]::setEnvironmentVariable('ELECTRON_CUSTOM_DIR', "30.0.6",'User')
[Environment]::setEnvironmentVariable('ELECTRON_BUILDER_BINARIES_MIRROR', "https://npmmirror.com/mirrors/electron-builder-binaries/",'User')
## end node

## python (pyenv-win)
$pyenvRoot = "$env:USERPROFILE\.pyenv\pyenv-win"
if (-not (Test-Path $pyenvRoot)) {
    
    git clone git@github.com:pyenv-win/pyenv-win.git "$env:USERPROFILE\.pyenv"
}

[Environment]::SetEnvironmentVariable('PYENV', "$env:USERPROFILE\.pyenv\pyenv-win", 'User')
[Environment]::SetEnvironmentVariable('PYENV_HOME', "$env:USERPROFILE\.pyenv\pyenv-win", 'User')
[Environment]::SetEnvironmentVariable('PYENV_ROOT', "$env:USERPROFILE\.pyenv\pyenv-win", 'User')
$env:PYENV = "$env:USERPROFILE\.pyenv\pyenv-win"
$env:PYENV_HOME = "$env:USERPROFILE\.pyenv\pyenv-win"
$env:PYENV_ROOT = "$env:USERPROFILE\.pyenv\pyenv-win"

$pyenvBin = "$env:USERPROFILE\.pyenv\pyenv-win\bin;$env:USERPROFILE\.pyenv\pyenv-win\shims"
$env:PATH = "$pyenvBin;$env:PATH"
[Environment]::SetEnvironmentVariable('Path', "$pyenvBin;$env:PATH", 'User')

# 初始化 pyenv
pyenv --version
pyenv update

# 替换 .versions_cache.xml 镜像为 npmmirror.com
$cacheFile = "$env:USERPROFILE\.pyenv\pyenv-win\.versions_cache.xml"
if (Test-Path $cacheFile) {
    (Get-Content $cacheFile) -replace "https://www\.python\.org/ftp/python/", "https://registry.npmmirror.com/-/binary/python/" | Set-Content $cacheFile
}

## end python

## go
./install_cmd.ps1 go
go env -w GO111MODULE=on
go env -w GOPROXY=https://goproxy.cn,direct
go install golang.org/x/tools/cmd/godoc@latest
## end go

## jdk17
./install_cmd.ps1 openjdk17

# -Dmaven.multiModuleProjectDirectory=$MAVEN_HOME -Dmaven.wagon.http.ssl.insecure=true -Dmaven.wagon.http.ssl.allowall=true -Dmaven.wagon.http.ssl.ignore.validity.dates=true
New-Item -Path $env:USERPROFILE\.m2\settings.xml -Type File -Force -Value(
@'
<settings xmlns="http://maven.apache.org/SETTINGS/1.0.0"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.0.0
                      http://maven.apache.org/xsd/settings-1.0.0.xsd">
  <localRepository/>
  <interactiveMode/>
  <usePluginRegistry/>
  <offline/>
  <pluginGroups/>
  <servers/>
  <mirrors>
    <mirror>
     <id>aliyunmaven</id>
     <mirrorOf>central</mirrorOf>
     <name>aliyun</name>
     <url>https://maven.aliyun.com/repository/central</url>
    </mirror>
    <mirror>
      <id>repo1</id>
      <mirrorOf>central</mirrorOf>
      <name>central repo</name>
      <url>http://repo1.maven.org/maven2/</url>
    </mirror>
    <mirror>
     <id>aliyunmaven</id>
     <mirrorOf>apache snapshots</mirrorOf>
     <name>aliyun-apache-snapshots</name>
     <url>https://maven.aliyun.com/repository/apache-snapshots</url>
    </mirror>
  </mirrors>
  <proxies/>
  <activeProfiles/>
  <profiles>
    <profile>  
        <repositories>
           <repository>
                <id>aliyunmaven</id>
                <name>aliyunmaven</name>
                <url>https://maven.aliyun.com/repository/public</url>
                <layout>default</layout>
                <releases>
                        <enabled>true</enabled>
                </releases>
                <snapshots>
                        <enabled>true</enabled>
                </snapshots>
            </repository>
            <repository>
                <id>MavenCentral</id>
                <url>http://repo1.maven.org/maven2/</url>
            </repository>
            <repository>
                <id>aliyunmavenApache</id>
                <url>https://maven.aliyun.com/repository/apache-snapshots</url>
            </repository>
        </repositories>
        <pluginRepositories>
            <pluginRepository>
                <id>aliyun-plugin</id>
                <url>https://maven.aliyun.com/repository/public</url>
                <releases>
                    <enabled>true</enabled>
                </releases>
                <snapshots>
                    <enabled>false</enabled>
                </snapshots>
            </pluginRepository>
        </pluginRepositories>             
     </profile>
  </profiles>
</settings>
'@
)
## end jdk17

## flutter
$env:PUB_HOSTED_URL="https://pub.flutter-io.cn"
$env:FLUTTER_STORAGE_BASE_URL="https://storage.flutter-io.cn"

New-Item -Path "$env:USERPROFILE\dev" -ItemType Directory
cd "$env:USERPROFILE\dev"


[System.Environment]::SetEnvironmentVariable('PUB_HOSTED_URL', 'https://pub.flutter-io.cn', 'User')
[System.Environment]::SetEnvironmentVariable('FLUTTER_STORAGE_BASE_URL', 'https://storage.flutter-io.cn', 'User')
# 将近1个G
Invoke-WebRequest -Uri "https://storage.flutter-io.cn/flutter_infra_release/releases/stable/windows/flutter_windows_3.24.5-stable.zip" -OutFile flutter-latest.zip
Expand-Archive .\flutter-latest.zip

$newPath = "$pwd\flutter-latest\flutter\bin;$env:PATH"
[System.Environment]::SetEnvironmentVariable('Path', $newPath, 'User')
$env:PATH = $pwd.PATH + "flutter-latest\flutter\bin",$env:PATH -join ";"

~\dev\flutter-latest\flutter\bin\flutter doctor
~\dev\flutter-latest\flutter\bin\flutter config --no-analytics
## end flutter
