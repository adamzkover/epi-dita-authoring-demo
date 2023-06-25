<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:f="http://hl7.org/fhir" xmlns:h="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="#all" version="3.0">

    <xsl:output indent="yes"/>

    <xsl:template match="h:img">
        <xsl:variable name="id" select="generate-id()"/>
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
            <xsl:attribute name="src">
                <xsl:value-of select="'#' || $id"/>
            </xsl:attribute>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="h:img/@data-format"/>

    <xsl:template match="f:Bundle">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
            <xsl:for-each select="//h:img">
                <xsl:variable name="id" select="generate-id()"/>
                <entry xmlns="http://hl7.org/fhir">
                    <fullUrl value="{'urn:uuid:' || $id}"/>
                    <resource>
                        <Binary>
                            <id value="{$id}"/>
                            <contentType>
                                <xsl:attribute name="value">
                                    <xsl:call-template name="contentType">
                                        <xsl:with-param name="format" select="@data-format"/>
                                    </xsl:call-template>
                                </xsl:attribute>
                            </contentType>
                            <data value="{@src}"/>
                        </Binary>
                    </resource>
                </entry>
            </xsl:for-each>
        </xsl:copy>
    </xsl:template>

    <xsl:template name="contentType">
        <xsl:param name="format"/>
        <xsl:choose>
            <xsl:when test="$format = 'jpg'">
                <xsl:text>image/jpeg</xsl:text>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>
