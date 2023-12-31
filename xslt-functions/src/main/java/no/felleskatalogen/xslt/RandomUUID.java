package no.felleskatalogen.xslt;

import java.util.UUID;

import net.sf.saxon.expr.XPathContext;
import net.sf.saxon.lib.ExtensionFunctionCall;
import net.sf.saxon.lib.ExtensionFunctionDefinition;
import net.sf.saxon.om.Sequence;
import net.sf.saxon.om.StructuredQName;
import net.sf.saxon.trans.XPathException;
import net.sf.saxon.value.SequenceType;
import net.sf.saxon.value.StringValue;

public class RandomUUID extends ExtensionFunctionDefinition {

    @Override
    public SequenceType[] getArgumentTypes() {
        return new SequenceType[] {};
    }

    @Override
    public StructuredQName getFunctionQName() {
        return new StructuredQName("fk", "http://felleskatalogen.no", "randomUUID");
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

                return StringValue.makeStringValue(UUID.randomUUID().toString());

            }

        };

    }

}
