this.regions = ["A821-A", "Aridia", "Black Rise", "Branch", "Cache", "Catch", "Cloud Ring", "Cobalt Edge", "Curse", "Deklein", "Delve", "Derelik", "Detorid", "Devoid", "Domain", "Esoteria", "Essence", "Etherium Reach", "Everyshore", "Fade", "Feythabolis", "Fountain", "Geminate", "Genesis", "Great Wildlands", "Heimatar", "Immensea", "Impass", "Insmother", "J7HZ-F", "Kador", "Khanid", "Kor-Azor", "Lonetrek", "Malpais", "Metropolis", "Molden Heath", "Oasa", "Omist", "Outer Passage", "Outer Ring", "Paragon Soul", "Period Basis", "Perrigen Falls", "Placid", "Providence", "Pure Blind", "Querious", "Scalding Pass", "Sinq Laison", "Solitude", "Stain", "Syndicate", "Tash-Murkon", "Tenal", "Tenerifis", "The Bleak Lands", "The Citadel", "The Forge", "The Kalevala Expanse", "The Spire", "Tribute", "Vale of the Silent", "Venal", "Verge Vendor", "Wicked Creek"]
Meteor.startup(function(){
    var states = new Bloodhound({
        datumTokenizer: Bloodhound.tokenizers.obj.whitespace('value'),
        queryTokenizer: Bloodhound.tokenizers.whitespace,
        // `states` is an array of state names defined in "The Basics"
        local: $.map(regions, function(state) { return { value: state }; })
    });

    states.initialize();

    window.ttregions = states.ttAdapter();
});
