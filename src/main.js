const Player = {
    score: 0,
    name: "",
    turn: true,
}

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
    document.getElementById("spielfeld").innerHTML = "<div class='bullseye_div'>"+returnSvgString(100, 100, "bullseye", true)+"</div>"
    document.getElementsByClassName("bullseye")[0].addEventListener("click", function(){
        givePoints(50);
    });
}
let returnSvgString = (height, width, classname, circle) => {
    if(circle){
        return "<svg width='"+width+"' height='"+height+"'><circle class='"+classname+"' cx='"+width/2+"' cy='"+height/2+"' r='40' stroke='black' stroke-width='3' fill='red' /></svg>";
    }else{
        return "<svg width='"+width+"' height='"+height+"'><polygon class='"+classname+"' points='0, 0, "+width+", 0, "+width/2+", "+height+"' fill='yellow' /></svg>"
    }
}