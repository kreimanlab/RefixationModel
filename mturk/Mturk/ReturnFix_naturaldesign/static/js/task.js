/*
 * Requires:
 *     psiturk.js
 *     utils.js
 */

// Initalize psiturk object
var psiTurk = new PsiTurk(uniqueId, adServerLoc, mode);

var mycondition = condition;  // these two variables are passed by the psiturk server process
var mycounterbalance = counterbalance;  // they tell you which condition you have been assigned to
// they are not used in the stroop code but may be useful to you

// All pages to be loaded
var pages = [
	"instructions/instruct-1.html",
	//"instructions/instruct-2.html",	
	"instructions/instruct-ready.html",
	"stage.html",
	"postquestionnaire.html"
];

psiTurk.preloadPages(pages);

var instructionPages = [ // add as a list as many pages as you like
	"instructions/instruct-1.html",
	//"instructions/instruct-2.html",	
	"instructions/instruct-ready.html"
];


/********************
* HTML manipulation
*
* All HTML files in the templates directory are requested
* from the server when the PsiTurk object is created above. We
* need code to get those pages from the PsiTurk object and
* insert them into the document.
*
********************/

/********************
* STROOP TEST       *
********************/

var StroopExperiment = function() {

	psiTurk.recordUnstructuredData("mode", mode);  

    //load text file

    var data_RNRlist=[];
	var data_Randlist=[];
	var TOTALTRIALNUM = 100;
	var SpetialTypeNum = 3; //number of special trials per type
	var TypeNum = 3; //3 spetial types
	var datasetname  = "naturaldesign";
	var trialindex =-1;

	var ajaxCall1 = $.get("static/ImageSet/random_" + datasetname + ".txt", function (data) { 
    	dataText = data.split("\n"); 
    	//console.log(dataText.length);
    	for(var i=0; i<dataText.length-1; i++) 
	  	{ 
	  		data_Randlist.push( dataText[i]);
	  	} 
    });
	var ajaxCall2 = $.get("static/ImageSet/RNR_" + datasetname + ".txt", function (data) {
		dataText = data.split("\n"); 
    	//console.log(dataText.length);
    	for(var i=0; i<dataText.length-1; i++) 
	  	{ 
	  		data_RNRlist.push( dataText[i]);
	  	} 
	});


	$.when(ajaxCall1, ajaxCall2).done(function () {
	// every AJAX call is done, do the rest...

	//initialize presentation list
	var data_Ptypelist = Array(TOTALTRIALNUM).fill(1)	
	//type: 4; patch from random picture
	//type: 3; patch from same category
	//type: 2; patch from same target image
	var counterR = TOTALTRIALNUM - TypeNum * SpetialTypeNum;
	for (var t=0; t<TypeNum; t++)
	{
		for (var i=0; i<SpetialTypeNum; i++)
		{
			data_Ptypelist[counterR] = t + 2;
			counterR = counterR + 1;
		}
	}
	data_Ptypelist = _.shuffle(data_Ptypelist);
	//console.log(data_Ptypelist)
    
	var data_Pimglist = _.range(0, data_RNRlist.length)	 
    data_Pimglist = _.shuffle(data_Pimglist);
    data_Pimglist = data_Pimglist.slice(0,TOTALTRIALNUM);
    //console.log(data_Pimglist);

    var data_Prandimglist = _.range(0, data_Randlist.length)	 
    data_Prandimglist = _.shuffle(data_Prandimglist);
    data_Prandimglist = data_Prandimglist.slice(0,SpetialTypeNum);
    //console.log(data_Prandimglist);
    
    //compile image list here
    var I1list = []; var I2list = []; var I3list = []; 
    counterR = 0;
    var gtlist = [];

    for (var i = 0; i<TOTALTRIALNUM; i++)
    {
    	var chosenimgind = data_Pimglist[i];
    	//console.log(chosenimgind);
    	var stimuliid = data_RNRlist[chosenimgind];
    	//console.log(stimuliid);
    	stimuliid = stimuliid.split("_");
    	//console.log(stimuliid);
    	stimuliid = stimuliid[1];
    	//console.log(stimuliid);

    	if (data_Ptypelist[i] == 1)
    	{
    		if (Math.random() < 0.5)
    		{
    			//var stimuliid = data_RNRlist[data_Pimglist[i]].split("_");
    			var imagename = "http://kreiman.hms.harvard.edu/mturk/mengmi/exp_ReturnFix/stimuli/" + datasetname + "/targetT/stimuli_" + stimuliid + "_targetT.jpg";    	
		    	I1list.push(imagename);
				var imagename = "http://kreiman.hms.harvard.edu/mturk/mengmi/exp_ReturnFix/stimuli/" + datasetname + "/RNR/" + data_RNRlist[data_Pimglist[i]] + "_nonReturn.jpg";    	
		    	I2list.push(imagename);
		    	var imagename = "http://kreiman.hms.harvard.edu/mturk/mengmi/exp_ReturnFix/stimuli/" + datasetname + "/RNR/" + data_RNRlist[data_Pimglist[i]] + "_Return.jpg";    	
		    	I3list.push(imagename);
		    	gtlist.push(2);
		    }else
		    {
		    	//var stimuliid = data_RNRlist[data_Pimglist[i]].split("_");
    			var imagename = "http://kreiman.hms.harvard.edu/mturk/mengmi/exp_ReturnFix/stimuli/" + datasetname + "/targetT/stimuli_" + stimuliid + "_targetT.jpg";    	
		    	I1list.push(imagename);
				var imagename = "http://kreiman.hms.harvard.edu/mturk/mengmi/exp_ReturnFix/stimuli/" + datasetname + "/RNR/" + data_RNRlist[data_Pimglist[i]] + "_nonReturn.jpg";    	
		    	I3list.push(imagename);
		    	var imagename = "http://kreiman.hms.harvard.edu/mturk/mengmi/exp_ReturnFix/stimuli/" + datasetname + "/RNR/" + data_RNRlist[data_Pimglist[i]] + "_Return.jpg";    	
		    	I2list.push(imagename);
		    	gtlist.push(1);
		    }
    	}
    	else if (data_Ptypelist[i] == 2)
		{
			if (Math.random() < 0.5)
			{
				//var stimuliid = data_RNRlist[data_Pimglist[i]].split("_");
				var imagename = "http://kreiman.hms.harvard.edu/mturk/mengmi/exp_ReturnFix/stimuli/" + datasetname + "/targetT/stimuli_" + stimuliid + "_targetT.jpg";    	
		    	I1list.push(imagename);
				I2list.push(imagename);
		    	var imagename = "http://kreiman.hms.harvard.edu/mturk/mengmi/exp_ReturnFix/stimuli/" + datasetname + "/RNR/" + data_RNRlist[data_Pimglist[i]] + "_nonReturn.jpg";    	
		    	I3list.push(imagename);
		    	gtlist.push(1);
		    }else
		    {
		    	
				var imagename = "http://kreiman.hms.harvard.edu/mturk/mengmi/exp_ReturnFix/stimuli/" + datasetname + "/targetT/stimuli_" + stimuliid + "_targetT.jpg";    	
		    	I1list.push(imagename);
				I3list.push(imagename);
		    	var imagename = "http://kreiman.hms.harvard.edu/mturk/mengmi/exp_ReturnFix/stimuli/" + datasetname + "/RNR/" + data_RNRlist[data_Pimglist[i]] + "_nonReturn.jpg";    	
		    	I2list.push(imagename);
		    	gtlist.push(2);
		    }
    	}
    	else if (data_Ptypelist[i] == 3)
    	{
    		if (Math.random() < 0.5)
    		{
    			//var stimuliid = data_RNRlist[data_Pimglist[i]].split("_");
    			var imagename = "http://kreiman.hms.harvard.edu/mturk/mengmi/exp_ReturnFix/stimuli/" + datasetname + "/targetT/stimuli_" + stimuliid + "_targetT.jpg";    	
		    	I1list.push(imagename);
				var imagename = "http://kreiman.hms.harvard.edu/mturk/mengmi/exp_ReturnFix/stimuli/" + datasetname + "/RNR/" + data_RNRlist[data_Pimglist[i]] + "_nonReturn.jpg";    	
		    	I2list.push(imagename);
		    	var imagename = "http://kreiman.hms.harvard.edu/mturk/mengmi/exp_ReturnFix/stimuli/" + datasetname + "/targetS/stimuli_" + stimuliid + "_targetS.jpg";    	
		    	I3list.push(imagename);
		    	gtlist.push(2);
		    }else
		    {
		    	//var stimuliid = data_RNRlist[data_Pimglist[i]].split("_");
    			var imagename = "http://kreiman.hms.harvard.edu/mturk/mengmi/exp_ReturnFix/stimuli/" + datasetname + "/targetT/stimuli_" + stimuliid + "_targetT.jpg";    	
		    	I1list.push(imagename);
				var imagename = "http://kreiman.hms.harvard.edu/mturk/mengmi/exp_ReturnFix/stimuli/" + datasetname + "/RNR/" + data_RNRlist[data_Pimglist[i]] + "_nonReturn.jpg";    	
		    	I3list.push(imagename);
		    	var imagename = "http://kreiman.hms.harvard.edu/mturk/mengmi/exp_ReturnFix/stimuli/" + datasetname + "/targetS/stimuli_" + stimuliid + "_targetS.jpg";    	
		    	I2list.push(imagename);
		    	gtlist.push(1);
		    }
		}
		else 
		{
			if (Math.random() < 0.5)
    		{
    			//var stimuliid = data_RNRlist[data_Pimglist[i]].split("_");
    			var imagename = "http://kreiman.hms.harvard.edu/mturk/mengmi/exp_ReturnFix/stimuli/" + datasetname + "/targetT/stimuli_" + stimuliid + "_targetT.jpg";    	
		    	I1list.push(imagename);
				var imagename = "http://kreiman.hms.harvard.edu/mturk/mengmi/exp_ReturnFix/stimuli/" + datasetname + "/RNR/" + data_RNRlist[data_Pimglist[i]] + "_nonReturn.jpg";    	
		    	I2list.push(imagename);
		    	var imagename = "http://kreiman.hms.harvard.edu/mturk/mengmi/exp_ReturnFix/stimuli/" + datasetname + "/random/" + data_Randlist[data_Prandimglist[counterR]];  
		    	counterR = counterR + 1;  	
		    	I3list.push(imagename);
		    	gtlist.push(1);
		    }else
		    {
		    	//var stimuliid = data_RNRlist[data_Pimglist[i]].split("_");
    			var imagename = "http://kreiman.hms.harvard.edu/mturk/mengmi/exp_ReturnFix/stimuli/" + datasetname + "/targetT/stimuli_" + stimuliid + "_targetT.jpg";    	
		    	I1list.push(imagename);
				var imagename = "http://kreiman.hms.harvard.edu/mturk/mengmi/exp_ReturnFix/stimuli/" + datasetname + "/RNR/" + data_RNRlist[data_Pimglist[i]] + "_nonReturn.jpg";    	
		    	I3list.push(imagename);
		    	var imagename = "http://kreiman.hms.harvard.edu/mturk/mengmi/exp_ReturnFix/stimuli/" + datasetname + "/random/" + data_Randlist[data_Prandimglist[counterR]];  
		    	counterR = counterR + 1;   	
		    	I2list.push(imagename);
		    	gtlist.push(2);
		    }
		}
    }


    console.log('All is prepared!');
    //console.log(I1list);
    //console.log(I2list);
    //console.log(I3list);
    //console.log(gtlist);

    psiTurk.preloadImages(I1list);
    psiTurk.preloadImages(I2list);
    psiTurk.preloadImages(I3list);


	// Stimuli for a basic Stroop experiment	
	psiTurk.recordUnstructuredData("condition", mycondition);
	psiTurk.recordUnstructuredData("counterbalance", mycounterbalance);
	
	var next = function() {
		if (I1list.length==0) {
			finish();
		}
		else {
			imageID1 = I1list[0];
			imageID2 = I2list[0];
			imageID3 = I3list[0];

			current_img = I1list.shift();	
			console.log(current_img);
			document.getElementById("stimT").src=current_img;
			//d3.select("#stimT").html('<img src='+current_img+' alt="stimuliT" style="width:10%" class="fblogo">');
			current_img = I2list.shift();
			console.log(current_img);
			document.getElementById("stimL").src=current_img;	
			//d3.select("#stimL").html('<img src='+current_img+' alt="stimuliL" style="width:10%" border ="0"  class="fblogo">');
			current_img = I3list.shift();	
			console.log(current_img);
			document.getElementById("stimR").src=current_img;
			//d3.select("#stimR").html('<img src='+current_img+' alt="stimuliR" style="width:10%" border ="0" class="fblogo">');

			trialindex = trialindex+1;					
			wordon = new Date().getTime();	
        
		}
	};

	var finish = function() {
		    //$("body").unbind("keydown", response_handler); // Unbind keys
		    currentview = new Questionnaire();
		};
		

	// Load the stage.html snippet into the body of the page
	psiTurk.showPage('stage.html');

	// Register the response handler that is defined above to handle any
	// key down events.
	//$("body").focus().keydown(response_handler);

	// Start the test; initialize everything
	next();
	document.getElementById("submittrial").addEventListener("click", mengmiClick);

	function mengmiClick() 
	{
		var response;
		var flagresponse = 0; //track only one radio button has been clicked
		if (document.getElementById('r1').checked) {				
				response = document.getElementById('r1').value;
				flagresponse = 1;			  
		}else if (document.getElementById('r2').checked) {
			response = document.getElementById('r2').value;
			flagresponse = 1;
		}else{
			window.alert("Warning: None of choices have been selected. Please choose one and ONLY one.");
		}

		if (flagresponse == 1)
		{
			var rt = new Date().getTime() - wordon;
	//		console.log(classname);
	//		console.log(choicename);
	//		console.log(response);

			psiTurk.recordTrialData({'phase':"TEST",
	                                 'imageT':imageID1, //image name presented 
	                                 'imageL':imageID2, //image name presented 
	                                 'imageR':imageID3, //image name presented                                
	                                 'response':response, //worker response for image name 
	                                 'stimuliseq':data_Pimglist[trialindex],  //image name presented
	                                 'typeseq':data_Ptypelist[trialindex],  //image name presented
	                                 'gtlabel':gtlist[trialindex], //image name presented	                                 
	                                 'counterbalance': mycounterbalance+1, //type of choices in that trial
	                                 'rt':rt, //response time	                                 
	                             	 'trial': trialindex+1} //trial index starting from 1
	                               );

			var ele = document.getElementsByName("choice");
		    for(var i=0;i<ele.length;i++){ele[i].checked = false;} //clear radio button

		    next();
		}

	}//end of mengmiClick function


	});//end of ajax call function



    
}; //end of stroop experiment function


/****************
* Questionnaire *
****************/

var Questionnaire = function() {

	var error_message = "<h1>Oops!</h1><p>Something went wrong submitting your HIT. This might happen if you lose your internet connection. Press the button to resubmit.</p><button id='resubmit'>Resubmit</button>";

	record_responses = function() {

		psiTurk.recordTrialData({'phase':'postquestionnaire', 'status':'submit'});

		$('select').each( function(i, val) {
			psiTurk.recordUnstructuredData(this.id, this.value);
		});

	};

	prompt_resubmit = function() {
		document.body.innerHTML = error_message;
		$("#resubmit").click(resubmit);
	};

	resubmit = function() {
		document.body.innerHTML = "<h1>Trying to resubmit...</h1>";
		reprompt = setTimeout(prompt_resubmit, 10000);

		psiTurk.saveData({
			success: function() {
			    clearInterval(reprompt);
				psiTurk.completeHIT();
			},
			error: prompt_resubmit
		});
	};

	// Load the questionnaire snippet
	psiTurk.showPage('postquestionnaire.html');
	psiTurk.recordTrialData({'phase':'postquestionnaire', 'status':'begin'});

	$("#next").click(function () {
	    record_responses();
	    psiTurk.saveData({
            success: function(){
            	psiTurk.completeHIT(); // when finished saving compute bonus, the quit
            },
            error: prompt_resubmit});
	});


};

// Task object to keep track of the current phase
var currentview;

/*******************
 * Run Task
 ******************/
$(window).load( function(){
    psiTurk.doInstructions(
    	instructionPages, // a list of pages you want to display in sequence
    	function() { currentview = new StroopExperiment(); } // what you want to do when you are done with instructions
    );
});
