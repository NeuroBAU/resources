var startTime;
var events = [];
var freezingInBins = [];
var freezingDataMs = [];
var intervals = [];
var intervalsInSeconds = [];
var binSize = 0;
var sessionInMinutes = 0;
var eventOn = false;
var started = false
var sessionDuration = 0;

function startTimer() {
    if (!started) {
        console.log('START . . . ')
        startTime = new Date();
        console.log(startTime);
        started = true;
        document.getElementById('sessionON').innerHTML = 'STARTED';
        document.getElementById('sessionInfo').innerHTML = '<b>Session started</b> | ' + startTime;
    } else {}
}

function stopTimer() {
    console.log('STOP');
    stopTime = new Date();
    sessionDuration = stopTime - startTime;
    console.log('session duration: ', stopTime - startTime);
    started = false;
    document.getElementById('sessionON').innerHTML = '';
}

function logEvent() {
    if (started) {
        eventOn = !eventOn;
        if (eventOn) {
            console.log('ongoing event ...');
            ongoingEventTimeStart = new Date();
            document.getElementById('feedbackEvent').innerHTML = 'FREEZING ON';
        } else {
            completedEventTimeStop = new Date();
            duration = completedEventTimeStop - ongoingEventTimeStart;
            console.log('event logged ', String(duration), ' ms');
            events.push({
                'duration': duration,
                'onset': ongoingEventTimeStart - startTime,
                'offset': completedEventTimeStop - startTime
            })
            document.getElementById('feedbackEvent').innerHTML = '';
            printDataOnScreen();
        }
    } else {
        alert("press start!");
    }
}

function printDataOnScreen() {
    if (!eventOn) {
        results = '<table class="table"><thead><tr><th>Onset</th><th>Duration</th><th>Offset</th></tr></thead><tbody>'
        console.log('time' + '\t' + 'duration')
        for (var i = 0; i < events.length; i++) {
            console.log(events[i].onset + '\t' + events[i].duration);
            results += '<tr><td>' + events[i].onset + '</td><td>' + events[i].duration + '</td><td>' + events[i].offset + '</td></tr>'
        }
        results += '</tbody>'
        document.getElementById('results').innerHTML = results;
        exportResults = results;
    }
    if (sessionDuration > 0) {}
}

function resetSession() {
    document.getElementById('results').innerHTML = '';
    events = [];
    eventOn = false;
    started = false
    sessionDuration = 0;
    console.log('STOP');
    stopTime = new Date();
    document.getElementById('sessionON').innerHTML = '';
    document.getElementById('sessionInfo').innerHTML = '<i class="fa fa-info"></i> | Session information';
    document.getElementById('feedbackEvent').innerHTML = '';
}


// build a range array
function range(start,stop) {
    return(Array.from(new Array(stop-start),(x,i)=>i+start));
}


// requires a function to build a range of indexes
// function splitFreezingInBins(sessionInMinutes,binSize){
function splitFreezingInBins(){

    // get input from user
    sessionInMinutes = document.getElementById('inputDuration').value;
    binSize = document.getElementById('inputBin').value;
    console.log(binSize);

    sessionInMilliseconds = sessionInMinutes*60*1000;

    // generate empty zeros array of desired length (milliseconds)
    freezingDataMs = [];
    for(var i = 0; i < sessionInMilliseconds; i++){
        freezingDataMs.push(0);
    }
    
    // update the freezingDataMs with actual freezing (indexes): NO-freezing=0; freezing=1
    for (var i = 0; i < events.length; i++) {
        rangeOfIndexes = range(events[i].onset,events[i].offset);
        for (var j = 0; j < rangeOfIndexes.length; j++) {
            freezingDataMs[rangeOfIndexes[j]]++
        }
    }

    intervalsInSeconds = sessionInMilliseconds/binSize;

    intervals = []
    count=0
    for (var i = 0; i < intervalsInSeconds; i++) {
        count=count+parseInt(binSize);
        intervals.push([count-binSize,count])
    }

    var db=[]
    for (var i = 0; i < intervals.length; i++) {
        var tmp = freezingDataMs.slice(intervals[i][0],intervals[i][1]);
        sum = tmp.reduce((pv, cv) => pv+cv, 0);
        db.push(sum)
    }

    return(db)
}



function analyze() {
    if (!eventOn) {
        freezingInBins = splitFreezingInBins();
        results='';
        results = '<table class="table"><thead><tr><th>Bin (s)</th><th>Duration (ms)</th><th>Duration (%)</th></tr></thead><tbody>'
        for (var i = 0; i < freezingInBins.length; i++) {
            results += '<tr><td>'+intervals[i][1]+'</td><td>' + freezingInBins[i] + '</td><td>'+(freezingInBins[i]*100)/binSize+'</td></tr>'
        }
        results += '</tbody>'
        document.getElementById('results').innerHTML = results;
    }
    else {
        alert("STOP session!");
    }
}



// enable window-wide keys (e.g. 'S' to start, 'F' to log freezing)
document.addEventListener("keydown", keyDownTextField, false);

function keyDownTextField(e) {
    var keyCode = e.keyCode;
    if (keyCode == 83) {
        startTimer();
    } else if (keyCode == 70) {
        logEvent();
    }
}