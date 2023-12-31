<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:f="http://hl7.org/fhir" xmlns:h="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:fk="http://felleskatalogen.no"
    exclude-result-prefixes="#all" version="3.0">

    <xsl:output indent="yes"/>

    <xsl:template match="h:img">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
            <xsl:attribute name="data-uuid" select="fk:randomUUID()"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>
