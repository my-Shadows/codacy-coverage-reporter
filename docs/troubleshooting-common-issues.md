# Troubleshooting common issues

The sections below provide instructions or workarounds to overcome common issues while using Codacy Coverage Reporter.

## Submitting coverage for unsupported languages

If your language is not in the list of supported languages, you can still send coverage to Codacy. You can do it by providing the correct `--language` name and then add the `--force-language` flag.

## Submitting coverage generated by unsupported tools

If the coverage report format of your coverage tool isn't supported yet, you can send the coverage data directly by calling the Codacy API endpoint [saveCoverage](https://api.codacy.com/swagger#savecoverage) (when using a project API Token) or [saveCoverageWithProjectName](https://api.codacy.com/swagger#savecoveragewithprojectname) (when using an account API Token).

The following is an example of the JSON payload:

```json
{
  "total": 23,
  "fileReports": [
    {
      "filename": "src/Codacy/Coverage/Parser/CloverParser.php",
      "total": 54,
      "coverage": {
        "3": 3,
        "5": 0,
        "7": 1
      }
    }
  ]
}
```

Note that all "coverable" lines should be present on the `coverage` node of the JSON payload. In the example you can see `"5": 0`, meaning that line 5 is not covered.

## Swift and Objective-C support {: id="swift-objectivec-support"}

To use Swift and Objective-C with Xcode coverage reports, use [Slather](https://github.com/SlatherOrg/slather) to convert the Xcode output into the Cobertura format.

To do this, execute the following commands on the CI:

```bash
gem install slather
slather coverage -x --output-directory <report-output-dir> --scheme <project-name> <project-name>.xcodeproj
```

This will generate a file `cobertura.xml` inside the folder `<report-output-dir>`.

After this, run Codacy Coverage Reporter:

```bash
bash <(curl -Ls https://coverage.codacy.com/get.sh)
```

## Can't guess any report due to no matching

Codacy Coverage Reporter automatically searches for coverage reports matching the [file name conventions for supported formats](index.md#generating-coverage).

However, if Codacy Coverage Reporter does not find your coverage report, you can explicitly define the report file name with the flag `--coverage-reports`. For example:

```bash
bash <(curl -Ls https://coverage.codacy.com/get.sh) report \
    --coverage-reports <my report>
```

## JsonParseException while uploading C# coverage data

If you are using dotCover to generate coverage reports for your C# projects, you should [exclude xUnit files](https://www.jetbrains.com/help/dotcover/Running_Coverage_Analysis_from_the_Command_LIne.html#filters_cmd) from the coverage analysis as follows:

```bash
dotCover.exe cover ... /Filters=-:xunit*
```

By default, dotCover includes xUnit files in the coverage analysis and this results in larger coverage reports. This filter helps ensure that the resulting coverage data does not exceed the size limit accepted by the Codacy API when uploading the results.

## SubstrateSegfaultHandler caught signal 11

If you are experiencing segmentation faults when uploading the coverage results due to [oracle/graal#624](https://github.com/oracle/graal/issues/624), execute the following command before running the reporter, as a workaround:

```sh
echo "$(dig +short api.codacy.com | tail -n1) api.codacy.com" >> /etc/hosts
```

## coverage-xml/index.xml generated an empty result

If you are using PHPUnit version 5 or above to generate your coverage report, you must output the report using the Clover format. Codacy Coverage Reporter supports the PHPUnit XML format only for versions 4 and older.

To change the output format replace the flag `--coverage-xml <dir>` with `--coverage-clover <file>` when executing `phpunit`.

See [PHPUnit command-line documentation](https://phpunit.readthedocs.io/en/latest/textui.html) for more information.