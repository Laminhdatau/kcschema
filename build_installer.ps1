# =====================================================================
# KYASCHEMA — Automated Release & Inno Setup Build Script
# Developer: KYACODETECH SOLUTION
# =====================================================================

Write-Host "==========================================================" -ForegroundColor Green
Write-Host "  KYASCHEMA - Automated Build & Installer Generator       " -ForegroundColor Green
Write-Host "==========================================================" -ForegroundColor Green
Write-Host ""

# Step 1: Build Release Windows Executable
Write-Host "[1/2] Building Flutter Windows Release binary..." -ForegroundColor Yellow
flutter build windows --release

if ($LASTEXITCODE -ne 0) {
    Write-Host "[ERROR] Flutter build failed. Please fix errors before compiling setup installer." -ForegroundColor Red
    exit 1
}

Write-Host "[OK] Release build completed successfully!" -ForegroundColor Green
Write-Host ""

# Step 2: Compile Inno Setup Script
Write-Host "[2/2] Compiling Inno Setup Installer (kyaschema.iss)..." -ForegroundColor Yellow

$isccPaths = @(
    "C:\Program Files (x86)\Inno Setup 6\ISCC.exe",
    "C:\Program Files\Inno Setup 6\ISCC.exe",
    "C:\Program Files (x86)\Inno Setup 5\ISCC.exe"
)

$isccPath = $null
foreach ($path in $isccPaths) {
    if (Test-Path $path) {
        $isccPath = $path
        break
    }
}

if ($isccPath) {
    Write-Host "Found Inno Setup Compiler at: $isccPath" -ForegroundColor Cyan
    & $isccPath "d:\PROJECT\kcschema\kyaschema.iss"

    if ($LASTEXITCODE -eq 0) {
        Write-Host ""
        Write-Host "==========================================================" -ForegroundColor Green
        Write-Host "  SETUP INSTALLER CREATED SUCCESSFULLY!                   " -ForegroundColor Green
        Write-Host "  File Location: d:\PROJECT\kcschema\installer_output\KYASCHEMA_Setup_v1.0.0.exe" -ForegroundColor Green
        Write-Host "==========================================================" -ForegroundColor Green
    } else {
        Write-Host "[ERROR] Inno Setup compilation failed." -ForegroundColor Red
    }
} else {
    Write-Host "[NOTE] Inno Setup Compiler (ISCC.exe) not detected at default location." -ForegroundColor Yellow
    Write-Host "Release files are ready at: d:\PROJECT\kcschema\build\windows\x64\runner\Release" -ForegroundColor Cyan
    Write-Host "You can open 'kyaschema.iss' in Inno Setup GUI and click 'Compile'." -ForegroundColor Cyan
}
