<?php

$queryTerm = $_GET['q'];
$queryTermEscaped = urlencode($queryTerm);
$baseURL = 'http://opac.sub.uni-goettingen.de/DB=1/XML=1/REC=1/SHRTST=50/';
$queryURL = $baseURL . 'CMD?ACT=SRCHA&IKT=1016&SRT=Dya&TRM=' . $queryTermEscaped;
$opacFeedXML = file_get_contents($queryURL);
$opacFeed = new DOMDocument();
$opacFeed->loadXML($opacFeedXML);

$currentURL = (!empty($_SERVER['HTTPS'])) ? "https://".$_SERVER['SERVER_NAME'].$_SERVER['REQUEST_URI'] : "http://".$_SERVER['SERVER_NAME'].$_SERVER['REQUEST_URI'];
date_default_timezone_set('Europe/Berlin');
$timeString = date(DATE_ATOM);

$XSL = new DOMDocument();
$XSLXML = file_get_contents('Opac-Shorttitle-to-Atom.xsl');
$XSL->loadXML($XSLXML);

$parameters = Array(
	'query' => $query,
	'queryEscaped' => $queryEscaped,
	'myURL' => $currentURL,
	'updated' => $timeString
);


$XSLTProc = new XSLTProcessor();
$XSLTProc->importStylesheet($XSL);
$XSLTProc->setParameter('', $parameters);
$atom = $XSLTProc->transformToXML($opacFeed);

echo($atom);

?>
