<?php
/**
 * opac-feed2.php
 * Loads 'SX20' formatted XML from the Opac and turns it into an Atom feed.
 *
 * April 2011 Sven-S. Porst <porst@sub.uni-goettingen.de>
 */

$queryTerm = $_GET['q'];
// $queryTerm = 'LKL IA 665';
$queryTermEscaped = urlencode($queryTerm);
$hitCount = 50;
$baseURL = 'https://opac.sub.uni-goettingen.de/DB=1/XML=1/PRS=SX20/FULLTITLE=1/REC=1/SHRTST=' . $hitCount . '/';
$queryURL = $baseURL . 'CMD?ACT=SRCHA&IKT=1016&SRT=LST_Dya&TRM=' . $queryTermEscaped . '+AND+NOT+SLK+%5Bar%5D*';

$queryLanguage = 'de';
if (array_key_exists('language', $_GET)) {
	$queryLanguage = $_GET['language'];
}

$opacFeedXML = file_get_contents($queryURL);
// The feed contains weirdly escaped 'markup' with plenty of &lt; entities.
// To make sense of that in XSL these need to be 'unescaped'.
// We just hope that this doesn’t break as badly in practice as it should in theory.
$opacFeedXML = str_replace(Array('&lt;', '&gt;'), Array('<', '>'), $opacFeedXML);
$opacFeed = new DOMDocument();
$opacFeed->loadXML($opacFeedXML);

$currentURL = (!empty($_SERVER['HTTPS'])) ? "https://".$_SERVER['SERVER_NAME'].$_SERVER['REQUEST_URI'] : "http://".$_SERVER['SERVER_NAME'].$_SERVER['REQUEST_URI'];
date_default_timezone_set('Europe/Berlin');
$timeString = date(DATE_ATOM);

$XSL = new DOMDocument();
$XSLXML = file_get_contents('Opac-SX20-to-Atom.xsl');
$XSL->loadXML($XSLXML);

$parameters = Array(
	'query' => $queryTerm,
	'queryEscaped' => $queryTermEscaped,
	'myURL' => $currentURL,
	'language' => $queryLanguage,
	'updated' => $timeString
);


$XSLTProc = new XSLTProcessor();
$XSLTProc->importStylesheet($XSL);
$XSLTProc->setParameter('', $parameters);
$atom = $XSLTProc->transformToXML($opacFeed);

header('Content-Type: application/atom+xml');
echo($atom);

?>
