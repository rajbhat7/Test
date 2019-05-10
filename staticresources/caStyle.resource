body .bPageBlock .pbTitle h2 {
  font-family: BloomSpeakCompBold;
  color: #239A98;
  font-size: 30px;
}

.individualPalette {
    margin: auto;
    width: 1200px;
    margin-top: 106px;
}

@font-face {
   font-family: 'BloomSpeakComp';
   src: url(/resource/UPC_Font_BloomSpeakComp); 
}
@font-face {
   font-family: 'BloomSpeakCompBold';
   src: url(/resource/UPC_Font_BloomSpeakComp_Bold); 
}
@font-face {
   font-family: 'BloomSpeakCompHeavy';
   src: url(/resource/UPC_Font_BloomSpeakComp_Heavy); 
}

body .bPageBlock,
body #bodyCell .bResource .secondaryPalette,
body .secondaryPalette.bPageBlock,
body .individualPalette .secondaryPalette.bPageBlock,
body .bodyDiv .genericTable,
body .genericPageBlockTable,
body .bodyDiv .bSubBlock,
body .bComponentBlock .bPageBlock,
body .bMyDashboard .bPageBlock,
body.rlHoverFrame .bPageBlock,
body.subjectSelectionPopup div.choicesBox,
body.lookupTab .secondaryPalette.bPageBlock,
body.popupTab .secondaryPalette.bPageBlock,
body.UserTagStatsPage .secondaryPalette.bPageBlock {
	background-color: white;
	border-bottom: 1px solid #eaeaea;
	border-left: 1px solid #eaeaea;
	border-right: 1px solid #eaeaea;
	-moz-border-radius: 4px;
	-webkit-border-radius: 4px;
	border-radius: 4px
}

/*
@font-face {
  font-family: BloomSpeakComp;
  src: url("{!URLFor($Resource.BloomSpeakComp,'BloomSpeakComp/BloomSpeakComp.ttf')}");
}

@font-face {
  font-family: BloomSpeakComp-Bold;
  src: url("{!URLFor($Resource.BloomSpeakComp,'BloomSpeakComp/BloomSpeakComp-Bold.ttf')}");
}
*/
.Custom19Tab .secondaryPalette, .individualPalette .Custom19Block .secondaryPalette {
    border-color: rgb(35,154,152);
}

.Custom19Tab .tertiaryPalette, .individualPalette .Custom19Block .tertiaryPalette, .layoutEdit .individualPalette .Custom19Block .tertiaryPalette {
    background-color: rgb(35,154,152);
    border-color: rgb(35,154,152);
}

.apexp .bPageBlock.apexDefaultPageBlock .pbHeader .pbTitle {
    vertical-align: baseline;
    padding-left: 0px;
}

.apexp .bPageBlock.apexDefaultPageBlock .pbBody .pbSubsection .detailList .data2Col.first.last .headerRow {
    display: none;
}

/*
.apexp .bPageBlock.apexDefaultPageBlock .pbHeader .pbTitle h2 {
	font-family: BloomSpeakComp;
	color: rgb(35,154,152);
	font-size: 16px;
}
.apexp .bPageBlock.apexDefaultPageBlock .pbBody .pbSubsection .detailList .data2Col.first.last span {
    font-family: BloomSpeakComp;
    font-size: 12.5px;
}
.apexp .bPageBlock.apexDefaultPageBlock .pbBody .pbSubsection .detailList .data2Col #radiocontrol {
    font-family: BloomSpeakComp;
    font-size: 12.5px;
}
.apexp .bPageBlock.apexDefaultPageBlock .pbBody .pbSubsection .detailList .data2Col.last {
    font-family: BloomSpeakComp-Bold;
    font-size: 12px;
}

.apexp .bPageBlock.apexDefaultPageBlock .pbBody .pbSubsection .detailList .data2Col.last .requiredInput textarea {
    font-family: BloomSpeakComp;
    font-size: 12.5px;
}
*/

.apexp .bPageBlock.apexDefaultPageBlock .pbBody .pbSubheader.brandTertiaryBgr.tertiaryPalette {
    display: none;
}

.apexp .bPageBlock.apexDefaultPageBlock .pbBody .pbSubheader.brandTertiaryBgr.tertiaryPalette .hideListButton {
    pointer-events: none;
}

body, td, textarea {
	font-family: BloomSpeakComp;
	font-size: 18px;
}

body {
	background-color: #E5E5E5;
}
body .pbHeader .pbButton {
    display: none;
}


body .pbBottomButtons .pbTitle {
    position: absolute;
    top: 0px;
    left: 0px;
    background-color: white;
    width: 100%;
    height: 74px;
    overflow: auto;
    vertical-align: middle;
    background-image: url(https://upc--devph2.cs101.content.force.com/servlet/servlet.ImageServer?id=0151X0000009B30&oid=00D1X0000008gN9);
    background-repeat: no-repeat;
    background-size: 125px;
    padding-left: 107px;
    background-position-x: calc(50% - 550px);
    background-position-y: center;
}

body .pbHeader .pbTitle + td {
    position: absolute;
    top: 0px;
    left: 0px;
    background-color: white;
    width: 100%;
    height: 74px;
    overflow: auto;
    vertical-align: middle;
    background-image: url(https://upc--devph2.cs101.content.force.com/servlet/servlet.ImageServer?id=0151X0000009B30&oid=00D1X0000008gN9);
    background-repeat: no-repeat;
    background-size: 125px;
    padding-left: 107px;
    background-position-x: calc(50% - 550px);
    background-position-y: center;
}

body button, body .x-btn, body .btn, body .btnDisabled, body .btnCancel, body .menuButton .menuButtonButton {
    color: white;
    margin: 1px;
    padding: 2px 3px;
    border: 1px solid #b5b5b5;
    background: #239A98;
    font-size: 15px;
    -moz-border-radius: 3px;
    -webkit-border-radius: 3px;
    border-radius: 3px;   
}

.bPageBlock {
    border-top: 0px;
}

p {
    margin-block-start: 0em;
    margin-block-end: 0em;
    margin-inline-start: 0px;
    margin-inline-end: 0px;
}

body input.btn,
body input.btnDisabled,
body input.btnCancel {
	padding: 4px 3px;
  width: 100%;
  margin: 10px;
}

.bPageBlock .detailList tr td, .bPageBlock .detailList tr th, .hoverDetail .bPageBlock .detailList tr td, .hoverDetail .bPageBlock .detailList tr th {
    border-bottom: none;
}

body .bEditBlock .pbBottomButtons, body .apexp .bPageBlock.apexDefaultPageBlock .pbBottomButtons {
    border-top: none;
}

body .bRelatedList .pbBody table.list, body .apexp .pbBody table.list {
    border: none;
}

.apexp .bPageBlock.apexDefaultPageBlock .pbBody .pbSubsection .detailList .data2Col.first.last .dataRow.even.first.last td:last-child {
    display: none;
}

.apexp .bPageBlock.apexDefaultPageBlock .pbBody .pbSubsection .detailList .data2Col.first.last .dataRow.even.first.last td:first-child a {
    font-size:0;
}

.apexp .bPageBlock.apexDefaultPageBlock .pbBody .pbSubsection .detailList .data2Col.first.last .dataRow.even.first.last td:first-child a:after {
  content: 'Terms and conditions';
  font-size:18px;         /* original font size */
}

.apexp .bPageBlock.apexDefaultPageBlock .pbBody {
    width: 592px;
    padding-left: 5px;
}

textarea {
    width: 586px;
    height: 132px;
}

.apexp .bPageBlock.brandSecondaryBrd.apexDefaultPageBlock.secondaryPalette .pbBody .pbSubsection .detailList .data2Col #radiocontrol {
    line-height: 40px;
}

.apexp .bPageBlock.brandSecondaryBrd.apexDefaultPageBlock.secondaryPalette .pbBottomButtons .pbButtonb .btn {
    margin-left: 0px;
    margin: unset;
    height: 37px;
    font-size: 20px;
    font-family: BloomSpeakCompHeavy;
}

.apexp .bPageBlock.brandSecondaryBrd.apexDefaultPageBlock.secondaryPalette .pbBottomButtons .pbButtonb {
    padding: unset;
}

body .apexp .bPageBlock.apexDefaultPageBlock .pbHeader {
    width: 1146px;
    padding-left: 27px;
    padding-right: 27px;
}

.apexp .bPageBlock.apexDefaultPageBlock .pbBody .pbSubsection .detailList .data2Col.last b {
    font-weight: unset;
}

body .apexp .bPageBlock.apexDefaultPageBlock .pbBottomButtons {
    margin-top: 0px;
}

body form[action="/CSCAP__CustomerApprovalConfirmation"] .apexp .bPageBlock.brandSecondaryBrd.apexDefaultPageBlock.secondaryPalette .pbBody .pbSubsection {
    width: 200%;
}

body form[action="/CSCAP__CustomerApprovalConfirmation"] .apexp .bPageBlock.brandSecondaryBrd.apexDefaultPageBlock.secondaryPalette .pbBody .pbSubsection .detailList .data2Col.first.last {
    background-image: url(/resource/ClickApprove_Accepted_Image);
    background-size: 200px;
    background-repeat: no-repeat;
    background-position-x: center;
    background-position-y: 80px;
    height: 510px;
    text-align: center;
    vertical-align: middle;
}