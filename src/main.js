const Player = {
    score: 0,
    name: "",
    turn: true,
}

const spielfeld_name_table = [
    "bullseye", 
    "bull",
    "20x1inner",
    "20x1outer",
    "20x2",
    "20x3"
];

const spielfeld_object_table_bullseye = [];
const spielfeld_object_table_bull = [];
const spielfeld_object_table_20x1inner = [];
const spielfeld_object_table_20x3 = [];
const spielfeld_object_table_20x1outer = [];
const spielfeld_object_table_20x2 = [];

const spielfeld_object_table_wrapper = [
    spielfeld_object_table_bullseye,
    spielfeld_object_table_bull,
    spielfeld_object_table_20x1inner,
    spielfeld_object_table_20x3,
    spielfeld_object_table_20x1outer,
    spielfeld_object_table_20x2
];

let returnSvgString = (height, width, classname, start_angle) => {
    if(classname === "bullseye"){
        let r = height + width / 2;
        r = r * 0.3;
        return "<svg width='"+width+"' height='"+height+"'><circle class='"+classname+"' cx='"+width/2+"' cy='"+height/2+"' r='"+r+"' stroke='black' stroke-width='3' fill='red' /></svg>";
    }if(classname === "bull"){
        return "<svg width='"+width+"' height='"+height+"'><circle class='"+classname+"' cx='"+width/2+"' cy='"+height/2+"' r='"+r+"' stroke='black' stroke-width='3' fill='red' /></svg>";
    }
    if(classname === "20x1inner"){
        return "<svg width='"+width+"' height='"+height+"'><polygon class='"+classname+"' points='0, 0, "+width+", 0, "+width/2+", "+height+"' fill='yellow' /></svg>"
    }
    if(classname === "20x3"){
        return "<svg width='"+width+"' height='"+height+"'><polygon class='"+classname+"' points='0, 0, "+width+", 0, "+width/2+", "+height+"' fill='yellow' /></svg>"
    }
    if(classname === "20x1outer"){
        return "<svg width='"+width+"' height='"+height+"'><polygon class='"+classname+"' points='0, 0, "+width+", 0, "+width/2+", "+height+"' fill='yellow' /></svg>"
    }
    if(classname === "20x2"){
        return "<svg width='"+width+"' height='"+height+"'><polygon class='"+classname+"' points='0, 0, "+width+", 0, "+width/2+", "+height+"' fill='yellow' /></svg>"
    }
}

class spielfeld_object {
    _points = 0;
    constructor(name, points, start_angle){
        this._name = name;
        this._points = points;
        this._start_angle = start_angle;
        this._svg_string = returnSvgString(33, 33, name, start_angle);
        this.createDocumentFragment();
    }
    get name(){
        return this._name;
    }
    get points(){
        return this._points;
    }
    get start_angle(){
        return this._start_angle;
    }
    get svg_string(){
        return this._svg_string;
    }
    createDocumentFragment(){
        document.getElementById("spielfeld").innerHTML = document.getElementById("spielfeld").innerHTML + 
                                                        "<div class='"+this.name+"_div'>"+this._svg_string+"</div>";
        document.getElementsByClassName(this._name)[0].addEventListener("click", function(){
            givePoints(this._points);
        });
    };
}
//test
let spielfeld_object1 = new spielfeld_object("bullseye", 50, 0);
console.log(spielfeld_object1);
//test
let player_1 = Object.create(Player);
let player_2 = Object.create(Player);
player_2.turn = false;

$("document").ready(function(){
    start();
});

let start = () => {
    console.log("Game started");
    erzeugeSpielfeld();
}

$(".plus10").click(function(){
    console.log("plus10 clicked");
    givePoints(10);
});

$(".plus20").click(function(){
    console.log("plus20 clicked");
    givePoints(20);
});

let givePoints = (points) => {
    if(player_1.turn){
        player_1.score += points;
    }
    if(player_2.turn){
        player_2.score += points;
    }
    update();
    console.log(player_1);
    console.log(player_2);
}

let update = () => { 
    player_1.turn = !player_1.turn;
    player_2.turn = !player_2.turn;  
    document.getElementById("player_1_score").innerHTML = player_1.score;
    document.getElementById("player_2_score").innerHTML = player_2.score;
};

let erzeugeSpielfeld = () => {
    //Bullseye,
    //Bull,
    //20 x 1x Felder, 
    //20 x 3x Felder,
    //weitere 20 x 1x Felder
    //20 x 2x Felder
}
