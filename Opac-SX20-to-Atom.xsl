<?xml version="1.0" encoding="UTF-8"?>
<!--
	April 2011
	Sven-S. Porst, SUB Göttingen <porst@sub.uni-goettingen.de>
-->
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	>

	<xsl:output indent="yes" method="xml" version="1.0" encoding="UTF-8" media-type="text"/>
	<xsl:param name="query"/>
	<xsl:param name="queryEscaped"/>
	<xsl:param name="myURL"/>
	<xsl:param name="updated"/>
	<xsl:param name="language"/>
	
	<xsl:variable name="opacURL">
		<xsl:text>http://opac.sub.uni-goettingen.de/DB=1/LNG=</xsl:text>
		<xsl:choose>
			<xsl:when test="$language = 'en'">EN</xsl:when>
			<xsl:otherwise>DU</xsl:otherwise>
		</xsl:choose>
		<xsl:text>/</xsl:text>
	</xsl:variable>
	
	<xsl:template match="@*|node()">
		<xsl:apply-templates select="@*|node()"/>
	</xsl:template>


	<xsl:template match="SET">
		<xsl:variable name="webURL">
			<xsl:value-of select="$opacURL"/>
			<xsl:text>CMD?ACT=SRCHA&amp;IKT=1016&amp;TRM=</xsl:text>
			<xsl:value-of select="$queryEscaped"/>
		</xsl:variable>

		<feed xmlns="http://www.w3.org/2005/Atom">
			<id><xsl:value-of select="$webURL"/></id>
			<title>
				<xsl:text>SUB Göttingen Opac </xsl:text>
				<xsl:choose>
					<xsl:when test="$language = 'en'">Query</xsl:when>
					<xsl:otherwise>Abfrage</xsl:otherwise>
				</xsl:choose>
				<xsl:text>: </xsl:text>
				<xsl:value-of select="$query"/>
			</title>
			<link rel="self">
				<xsl:attribute name="href">
					<xsl:value-of select="$myURL"/>
				</xsl:attribute>
			</link>
			<link rel="alternate">
				<xsl:attribute name="href">
					<xsl:value-of select="$webURL"/>
				</xsl:attribute>
			</link>
			<updated><xsl:value-of select="$updated"/></updated>
 			<author>
				<name>SUB Göttingen Opac</name>
				<uri><xsl:value-of select="$opacURL"/></uri>
			</author>
			<generator>Opac-Shorttitle-to-Atom.xsl</generator>

			<xsl:apply-templates select="SHORTTITLE"/>

		</feed>
	</xsl:template>


	<xsl:template match="SHORTTITLE">
		<xsl:variable name="PPN" select="@matstring"/>
		<xsl:variable name="PPNWebURL">
			<xsl:value-of select="$opacURL"/>
			<xsl:text>PPNSET?PPN=</xsl:text>
			<xsl:value-of select="$PPN"/>
		</xsl:variable>
		<xsl:variable name="bookName" select="text()"/>

		<entry xmlns="http://www.w3.org/2005/Atom">
			<id><xsl:value-of select="$PPNWebURL"/></id>
			<title>
				<xsl:value-of select="ous/title"/>
				<xsl:text> – </xsl:text>
				<xsl:value-of select="ous/author"/>
			</title>
			<link rel="alternate">
				<xsl:attribute name="href">
					<xsl:value-of select="$PPNWebURL"/>
				</xsl:attribute>
			</link>
			<updated>
				<xsl:text>20</xsl:text>
				<xsl:value-of select="substring(ous/date_availability, 7, 2)"/>
				<xsl:text>-</xsl:text>
				<xsl:value-of select="substring(ous/date_availability, 4, 2)"/>
				<xsl:text>-</xsl:text>
				<xsl:value-of select="substring(ous/date_availability, 1, 2)"/>
				<xsl:text>T02:00:00+01:00</xsl:text>
			</updated>
			<content type="xhtml">
				<div xmlns="http://www.w3.org/1999/xhtml">
					<xsl:for-each select="ous/signature">
						<p>
							<xsl:choose>
								<xsl:when test="$language = 'en'">Shelf mark</xsl:when>
								<xsl:otherwise>Signatur</xsl:otherwise>
							</xsl:choose>
							<xsl:text>: </xsl:text>
							<xsl:value-of select="."/>
						</p>
					</xsl:for-each>
					<p>
						<a>
							<xsl:attribute name="href">
								<xsl:value-of select="$PPNWebURL"/>
							</xsl:attribute>
							<xsl:choose>
								<xsl:when test="$language = 'en'">View in Opac</xsl:when>
								<xsl:otherwise>Im Opac ansehen</xsl:otherwise>
							</xsl:choose>
						</a>
					</p>
				</div>
			</content>
		</entry>
	</xsl:template>

</xsl:stylesheet>
