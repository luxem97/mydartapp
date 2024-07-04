const Player = {
    score: 0,
    name: "",
}
let player_1 = Object.create(Player);
let player_2 = Object.create(Player);
let currentPlayer = player_1;
$("document").ready(function(){
    start();
});
let start = () => {
    console.log("Game started");
}
$(".plus20").click(function(){
    currentPlayer.score += 20;
    currentPlayer === player_1 ? currentPlayer = player_2 : currentPlayer = player_1;
    update();
});
let update = () => {
    
    if(player_1.score != null || player_1.score != undefined){
        console.log($(".plus5"));
    }
    if(player_2.score != null || player_2.score != undefined){
        console.log("kommt rein?");
    }
};