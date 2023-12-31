package no.felleskatalogen.xslt;

import java.io.IOException;
import java.io.UncheckedIOException;
import java.net.URI;
import java.net.URISyntaxException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Base64;

import net.sf.saxon.expr.XPathContext;
import net.sf.saxon.lib.ExtensionFunctionCall;
import net.sf.saxon.lib.ExtensionFunctionDefinition;
import net.sf.saxon.om.Sequence;
import net.sf.saxon.om.StructuredQName;
import net.sf.saxon.trans.XPathException;
import net.sf.saxon.value.SequenceType;
import net.sf.saxon.value.StringValue;

public class ReadBinaryData extends ExtensionFunctionDefinition {

    @Override
    public SequenceType[] getArgumentTypes() {
        return new SequenceType[] { SequenceType.SINGLE_STRING, SequenceType.SINGLE_STRING,
            SequenceType.SINGLE_STRING, SequenceType.SINGLE_STRING };
    }

    @Override
    public StructuredQName getFunctionQName() {
        return new StructuredQName("fk", "http://felleskatalogen.no", "readBinaryData");
    }

    @Override
    public SequenceType getResultType(SequenceType[] suppliedArgumentTypes) {
        return SequenceType.SINGLE_STRING;
    }

    @Override
    public ExtensionFunctionCall makeCallExpression() {
        return new ExtensionFunctionCall() {

            @Override
            public Sequence call(XPathContext context, Sequence[] arguments) throws XPathException {

                // Input parameters
                String inputDir = arguments[0].head().getStringValue();
                String tempDir = arguments[1].head().getStringValue();
                String documentUri = arguments[2].head().getStringValue();
                String href = arguments[3].head().getStringValue();

                // Get the directory of the current document
                Path documentPath = null;
                try {
                    documentPath = Paths.get(new URI(documentUri));
                } catch (URISyntaxException e) {
                    throw new RuntimeException(e);
                }

                Path tempDirPath = Paths.get(tempDir);
                Path documentDirPath = documentPath.getParent();
                Path documentDirRelativePath = tempDirPath.relativize(documentDirPath);

                Path imagePath = Paths.get(inputDir, documentDirRelativePath.toString(), href);

                // Read binary data and return as Base64 encoded string
                try {
                    byte[] imageData = Files.readAllBytes(imagePath);
                    return StringValue.makeStringValue(Base64.getEncoder().encodeToString(imageData));
                } catch (IOException e) {
                    throw new UncheckedIOException(e);
                }

            }

        };

    }

}
