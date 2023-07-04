# epi-dita-authoring-demo

Demo of FHIR ePI authoring using DITA XML source files.

1. Install [DITA Open Toolkit 4.1](https://www.dita-ot.org/)
1. `mvn package` the project in `xslt-functions`
1. Copy the JAR file from the target directory to `no.felleskatalogen.fhir.epi.dita/lib`
1. Copy the `no.felleskatalogen.fhir.epi.dita` directory to the DITA-OT plug-in directory
1. Install the plugin with `dita install`
1. Convert the DITA maps to FHIR ePIs, e.g. `dita -i template/package-leaflet-bundle.ditamap -f fhir-epi`

The FHIR ePI result is saved to the `out` directory.

The DITA maps and topic files in the `template` directory represent content that might come from a DITA-based CMS.

Topic `.dita` files can be reused in several maps, for example to share static content between package leaflets. The maps can be extended with more topics. Topics with `data[@name = 'sectionId']` are converted to Composition.section. Other topics are added as HTML div elements to the parent section text.

Links

* [DITA-OT Implementing Saxon extension functions](https://www.dita-ot.org/dev/topics/implement-saxon-extension-functions.html)
* [DITA-OT Adding a Java library to the classpath](https://www.dita-ot.org/dev/topics/plugin-javalib.html)
