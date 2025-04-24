$script:currentBuild = ""
$script:results = @{}

# Define the two builds to compare
$builds = @{
    "build1" = "D:\fork\ballerina-lang\distribution\zip\jballerina-tools\build\extracted-distributions\jballerina-tools-2201.13.0-SNAPSHOT\bin\bal.bat"
    "build2" = "bal"
}

# List of files to test
$files = @("simple.bal", "complex.bal", "nested.bal")

# Create output directory
$outputDir = "results_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
New-Item -ItemType Directory -Path $outputDir | Out-Null

function Run-Test($buildName, $buildCmd, $file) {
    $logFile = Join-Path $outputDir "$buildName`_$($file.Replace('.bal',''))_log.txt"
    Write-Host "Running $buildName on $file..."
    
    # Run the Ballerina program and capture output
    & $buildCmd run $file 2>&1 | Tee-Object -FilePath $logFile
    
    # Parse average time from log
    $content = Get-Content $logFile -Raw
    if ($content -match 'Average execution time: (\d+\.?\d*) seconds') {
        $avgTime = $matches[1]
        $script:results["$buildName`_$file"] = $avgTime
    }
}

# Execute tests for both builds
foreach ($build in $builds.GetEnumerator()) {
    $script:currentBuild = $build.Name
    foreach ($file in $files) {
        if (Test-Path $file) {
            Run-Test -buildName $build.Name -buildCmd $build.Value -file $file
        }
        else {
            Write-Warning "File $file not found!"
        }
    }
}

# Generate summary report
$summaryFile = Join-Path $outputDir "summary.txt"
$report = @"
=================================
      PERFORMANCE SUMMARY
=================================

"@

foreach ($file in $files) {
    $build1Time = $script:results["build1_$file"]
    $build2Time = $script:results["build2_$file"]
    
    $report += @"


File: $file
---------------------------------
Build 1 (Snapshot): $build1Time seconds
Build 2 (Stable):   $build2Time seconds
"@
}

$report | Out-File $summaryFile
Write-Host "`nTest complete! Results saved to: $outputDir`n"
Write-Host "=== Final Summary ==="
Get-Content $summaryFile