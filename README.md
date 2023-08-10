# epi-dita-authoring-demo

Demo of FHIR ePI authoring using DITA XML source files. The built-in PDF and HTML DITA plug-ins can be used to generate PDF and HTML output from the same source files.

1. Install Java 11 or later and [Maven](https://maven.apache.org/).
1. Install [DITA Open Toolkit 4.1](https://www.dita-ot.org/)
1. `mvn package` the project in `xslt-functions`
1. Copy the JAR file from the target directory to `no.felleskatalogen.fhir.epi.dita/lib`
1. Copy the `no.felleskatalogen.fhir.epi.dita` directory to the DITA-OT plug-in directory
1. Install the plug-in with `dita install`
1. Convert the DITA maps to FHIR ePI with `dita -i template/package-leaflet-bundle.ditamap -f fhir-epi`
1. Check the FHIR ePI result in the `out` directory.
1. Validate the FHIR ePI with [the official FHIR validator](https://github.com/hapifhir/org.hl7.fhir.core/releases/latest/download/validator_cli.jar), e.g. `java -jar /path/to/validator_cli.jar out/package-leaflet-bundle.xml`


The DITA maps and topic files in the `template` directory represent content that might come from a DITA-based CMS.

Topic `.dita` files can be reused in several maps, for example to share static content between package leaflets. The maps can be extended with more topics. Topics with `data[@name = 'sectionId']` are converted to Composition.section. Other topics are added as HTML div elements to the parent section text.

The XSLTs need functionality that is not available in Saxon HE, these are impleented in extension functions in `xslt-functions`.

Links

* [DITA-OT Implementing Saxon extension functions](https://www.dita-ot.org/4.1/topics/implement-saxon-extension-functions.html)
* [DITA-OT Adding Saxon customizations](https://www.dita-ot.org/4.1/topics/implement-saxon-customizations.html)
* [DITA-OT Adding a Java library to the classpath](https://www.dita-ot.org/4.1/topics/plugin-javalib.html)
* [DITA-OT Parameters](https://www.dita-ot.org/4.1/parameters/parameters_intro.html)
