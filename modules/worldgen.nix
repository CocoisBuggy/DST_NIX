{
  lib,
  ...
}:

with lib;
{
  # circa 2021
  # https://forums.kleientertainment.com/forums/topic/127830-worldgenoverridelua-settings-for-march-qol-update/
  # or an older example from 2016
  # https://forums.kleientertainment.com/forums/topic/53014-worldgenoverridelua-with-the-new-post-caves-settings/#comment-630926
  settings = types.submodule (
    { name, ... }:
    {
      options = {
        specialevent = mkOption {
          type = types.enum [
            "default"
            "none"
            "hallowed_nights"
            "winters_feast"
            "crow_carnival"
            "year_of_the_gobbler"
            "year_of_the_varg"
            "year_of_the_pig"
            "year_of_the_carrat"
            "year_of_the_beefalo"
          ];
          default = "default";
          description = "Global | Events";
        };
        autumn = mkOption {
          type = types.enum [
            "noseason"
            "veryshortseason"
            "shortseason"
            "default"
            "longseason"
            "verylongseason"
            "random"
          ];
          default = "default";
          description = "Global | Autumn";
        };
        winter = mkOption {
          type = types.enum [
            "noseason"
            "veryshortseason"
            "shortseason"
            "default"
            "longseason"
            "verylongseason"
            "random"
          ];
          default = "default";
          description = "Global | Winter";
        };
        spring = mkOption {
          type = types.enum [
            "noseason"
            "veryshortseason"
            "shortseason"
            "default"
            "longseason"
            "verylongseason"
            "random"
          ];
          default = "default";
          description = "Global | Spring";
        };
        summer = mkOption {
          type = types.enum [
            "noseason"
            "veryshortseason"
            "shortseason"
            "default"
            "longseason"
            "verylongseason"
            "random"
          ];
          default = "default";
          description = "Global | Summer";
        };
        day = mkOption {
          type = types.enum [
            "default"
            "longday"
            "longdusk"
            "longnight"
            "noday"
            "nodusk"
            "nonight"
            "onlyday"
            "onlydusk"
            "onlynight"
          ];
          default = "default";
          description = "Global | Day Type";
        };
        beefaloheat = mkOption {
          type = types.enum [
            "never"
            "rare"
            "default"
            "often"
            "always"
          ];
          default = "default";
          description = "Global | Beefalo Mating Frequency";
        };
        krampus = mkOption {
          type = types.enum [
            "never"
            "rare"
            "default"
            "often"
            "always"
          ];
          default = "default";
          description = "Global | Krampii";
        };
        extrastartingitems = mkOption {
          type = types.enum [
            "0"
            "5"
            "default"
            "15"
            "20"
            "none"
          ];
          default = "default";
          description = "Survivors | Extra Starting Resources";
        };
        seasonalstartingitems = mkOption {
          type = types.enum [
            "never"
            "default"
          ];
          default = "default";
          description = "Survivors | Seasonal Starting Items";
        };
        spawnprotection = mkOption {
          type = types.enum [
            "never"
            "default"
            "always"
          ];
          default = "default";
          description = "Survivors | Griefer Spawn Protection";
        };
        dropeverythingondespawn = mkOption {
          type = types.enum [
            "default"
            "always"
          ];
          default = "default";
          description = "Survivors | Drop Items on Disconnect";
        };
        brightmarecreatures = mkOption {
          type = types.enum [
            "never"
            "rare"
            "default"
            "often"
            "always"
          ];
          default = "default";
          description = "Survivors | Enlightenment Monsters";
        };
        shadowcreatures = mkOption {
          type = types.enum [
            "never"
            "rare"
            "default"
            "often"
            "always"
          ];
          default = "default";
          description = "Survivors | Sanity Monsters";
        };
        petrification = mkOption {
          type = types.enum [
            "none"
            "few"
            "default"
            "many"
            "max"
          ];
          default = "default";
          description = "World | Forest Petrification";
        };
        frograin = mkOption {
          type = types.enum [
            "never"
            "rare"
            "default"
            "often"
            "always"
          ];
          default = "default";
          description = "World | Frog Rain";
        };
        hounds = mkOption {
          type = types.enum [
            "never"
            "rare"
            "default"
            "often"
            "always"
          ];
          default = "default";
          description = "World | Hound Attacks";
        };
        alternatehunt = mkOption {
          type = types.enum [
            "never"
            "rare"
            "default"
            "often"
            "always"
          ];
          default = "default";
          description = "World | Hunt Surprises";
        };
        hunt = mkOption {
          type = types.enum [
            "never"
            "rare"
            "default"
            "often"
            "always"
          ];
          default = "default";
          description = "World | Hunts";
        };
        lightning = mkOption {
          type = types.enum [
            "never"
            "rare"
            "default"
            "often"
            "always"
          ];
          default = "default";
          description = "World | Lightning";
        };
        meteorshowers = mkOption {
          type = types.enum [
            "never"
            "rare"
            "default"
            "often"
            "always"
          ];
          default = "default";
          description = "World | Meteor Frequency";
        };
        weather = mkOption {
          type = types.enum [
            "never"
            "rare"
            "default"
            "often"
            "always"
          ];
          default = "default";
          description = "World | Rain";
        };
        wildfires = mkOption {
          type = types.enum [
            "never"
            "rare"
            "default"
            "often"
            "always"
          ];
          default = "default";
          description = "World | Wildfires";
        };
        regrowth = mkOption {
          type = types.enum [
            "never"
            "veryslow"
            "slow"
            "default"
            "fast"
            "veryfast"
          ];
          default = "default";
          description = "Resource Regrowth | Regrowth Multiplier";
        };
        deciduoustree_regrowth = mkOption {
          type = types.enum [
            "never"
            "veryslow"
            "slow"
            "default"
            "fast"
            "veryfast"
          ];
          default = "default";
          description = "Resource Regrowth | Birchnut Trees";
        };
        carrots_regrowth = mkOption {
          type = types.enum [
            "never"
            "veryslow"
            "slow"
            "default"
            "fast"
            "veryfast"
          ];
          default = "default";
          description = "Resource Regrowth | Carrots";
        };
        evergreen_regrowth = mkOption {
          type = types.enum [
            "never"
            "veryslow"
            "slow"
            "default"
            "fast"
            "veryfast"
          ];
          default = "default";
          description = "Resource Regrowth | Evergreens";
        };
        flowers_regrowth = mkOption {
          type = types.enum [
            "never"
            "veryslow"
            "slow"
            "default"
            "fast"
            "veryfast"
          ];
          default = "default";
          description = "Resource Regrowth | Flowers";
        };
        moon_tree_regrowth = mkOption {
          type = types.enum [
            "never"
            "veryslow"
            "slow"
            "default"
            "fast"
            "veryfast"
          ];
          default = "default";
          description = "Resource Regrowth | Lune Trees";
        };
        saltstack_regrowth = mkOption {
          type = types.enum [
            "never"
            "veryslow"
            "slow"
            "default"
            "fast"
            "veryfast"
          ];
          default = "default";
          description = "Resource Regrowth | Salt Formations";
        };
        twiggytrees_regrowth = mkOption {
          type = types.enum [
            "never"
            "veryslow"
            "slow"
            "default"
            "fast"
            "veryfast"
          ];
          default = "default";
          description = "Resource Regrowth | Twiggy Trees";
        };
        bees_setting = mkOption {
          type = types.enum [
            "never"
            "rare"
            "default"
            "often"
            "always"
          ];
          default = "default";
          description = "Creatures | Bees";
        };
        birds = mkOption {
          type = types.enum [
            "never"
            "rare"
            "default"
            "often"
            "always"
          ];
          default = "default";
          description = "Creatures | Birds";
        };
        bunnymen_setting = mkOption {
          type = types.enum [
            "never"
            "rare"
            "default"
            "often"
            "always"
          ];
          default = "default";
          description = "Creatures | Bunnymen";
        };
        butterfly = mkOption {
          type = types.enum [
            "never"
            "rare"
            "default"
            "often"
            "always"
          ];
          default = "default";
          description = "Creatures | Butterflies";
        };
        catcoons = mkOption {
          type = types.enum [
            "never"
            "rare"
            "default"
            "often"
            "always"
          ];
          default = "default";
          description = "Creatures | Catcoons";
        };
        gnarwail = mkOption {
          type = types.enum [
            "never"
            "rare"
            "default"
            "often"
            "always"
          ];
          default = "default";
          description = "Creatures | Gnarwails";
        };
        perd = mkOption {
          type = types.enum [
            "never"
            "rare"
            "default"
            "often"
            "always"
          ];
          default = "default";
          description = "Creatures | Gobblers";
        };
        grassgekkos = mkOption {
          type = types.enum [
            "never"
            "rare"
            "default"
            "often"
            "always"
          ];
          default = "default";
          description = "Creatures | Grass Gekko Morphing";
        };
        moles_setting = mkOption {
          type = types.enum [
            "never"
            "rare"
            "default"
            "often"
            "always"
          ];
          default = "default";
          description = "Creatures | Moles";
        };
        penguins = mkOption {
          type = types.enum [
            "never"
            "rare"
            "default"
            "often"
            "always"
          ];
          default = "default";
          description = "Creatures | Pengulls";
        };
        pigs_setting = mkOption {
          type = types.enum [
            "never"
            "rare"
            "default"
            "often"
            "always"
          ];
          default = "default";
          description = "Creatures | Pigs";
        };
        rabbits_setting = mkOption {
          type = types.enum [
            "never"
            "rare"
            "default"
            "often"
            "always"
          ];
          default = "default";
          description = "Creatures | Rabbits";
        };
        fishschools = mkOption {
          type = types.enum [
            "never"
            "rare"
            "default"
            "often"
            "always"
          ];
          default = "default";
          description = "Creatures | Schools of Fish";
        };
        wobsters = mkOption {
          type = types.enum [
            "never"
            "rare"
            "default"
            "often"
            "always"
          ];
          default = "default";
          description = "Creatures | Wobsters";
        };
        bats_setting = mkOption {
          type = types.enum [
            "never"
            "rare"
            "default"
            "often"
            "always"
          ];
          default = "default";
          description = "Hostile Creatures | Bats";
        };
        cookiecutters = mkOption {
          type = types.enum [
            "never"
            "rare"
            "default"
            "often"
            "always"
          ];
          default = "default";
          description = "Hostile Creatures | Cookie Cutters";
        };
        frogs = mkOption {
          type = types.enum [
            "never"
            "rare"
            "default"
            "often"
            "always"
          ];
          default = "default";
          description = "Hostile Creatures | Frogs";
        };
        mutated_hounds = mkOption {
          type = types.enum [
            "never"
            "default"
          ];
          default = "default";
          description = "Hostile Creatures | Horror Hounds";
        };
        hound_mounds = mkOption {
          type = types.enum [
            "never"
            "rare"
            "default"
            "often"
            "always"
          ];
          default = "default";
          description = "Hostile Creatures | Hounds";
        };
        wasps = mkOption {
          type = types.enum [
            "never"
            "rare"
            "default"
            "often"
            "always"
          ];
          default = "default";
          description = "Hostile Creatures | Killer Bees";
        };
        lureplants = mkOption {
          type = types.enum [
            "never"
            "rare"
            "default"
            "often"
            "always"
          ];
          default = "default";
          description = "Hostile Creatures | Lureplants";
        };
        walrus_setting = mkOption {
          type = types.enum [
            "never"
            "rare"
            "default"
            "often"
            "always"
          ];
          default = "default";
          description = "Hostile Creatures | MacTusk";
        };
        merms = mkOption {
          type = types.enum [
            "never"
            "rare"
            "default"
            "often"
            "always"
          ];
          default = "default";
          description = "Hostile Creatures | Merms";
        };
        penguins_moon = mkOption {
          type = types.enum [
            "never"
            "default"
          ];
          default = "default";
          description = "Hostile Creatures | Moonrock Pengulls";
        };
        mosquitos = mkOption {
          type = types.enum [
            "never"
            "rare"
            "default"
            "often"
            "always"
          ];
          default = "default";
          description = "Hostile Creatures | Mosquitos";
        };
        sharks = mkOption {
          type = types.enum [
            "never"
            "rare"
            "default"
            "often"
            "always"
          ];
          default = "default";
          description = "Hostile Creatures | Sharks";
        };
        moon_spider = mkOption {
          type = types.enum [
            "never"
            "rare"
            "default"
            "often"
            "always"
          ];
          default = "default";
          description = "Hostile Creatures | Shattered Spiders";
        };
        squid = mkOption {
          type = types.enum [
            "never"
            "rare"
            "default"
            "often"
            "always"
          ];
          default = "default";
          description = "Hostile Creatures | Skittersquids";
        };
        spider_warriors = mkOption {
          type = types.enum [
            "never"
            "default"
          ];
          default = "default";
          description = "Hostile Creatures | Spider Warriors";
        };
        spiders_setting = mkOption {
          type = types.enum [
            "never"
            "rare"
            "default"
            "often"
            "always"
          ];
          default = "default";
          description = "Hostile Creatures | Spiders";
        };
        antliontribute = mkOption {
          type = types.enum [
            "never"
            "rare"
            "default"
            "often"
            "always"
          ];
          default = "default";
          description = "Giants | Antlion Tribute";
        };
        bearger = mkOption {
          type = types.enum [
            "never"
            "rare"
            "default"
            "often"
            "always"
          ];
          default = "default";
          description = "Giants | Bearger";
        };
        beequeen = mkOption {
          type = types.enum [
            "never"
            "rare"
            "default"
            "often"
            "always"
          ];
          default = "default";
          description = "Giants | Bee Queen";
        };
        crabking = mkOption {
          type = types.enum [
            "never"
            "rare"
            "default"
            "often"
            "always"
          ];
          default = "default";
          description = "Giants | Crabking";
        };
        deerclops = mkOption {
          type = types.enum [
            "never"
            "rare"
            "default"
            "often"
            "always"
          ];
          default = "default";
          description = "Giants | Deerclops";
        };
        dragonfly = mkOption {
          type = types.enum [
            "never"
            "rare"
            "default"
            "often"
            "always"
          ];
          default = "default";
          description = "Giants | Dragonfly";
        };
        klaus = mkOption {
          type = types.enum [
            "never"
            "rare"
            "default"
            "often"
            "always"
          ];
          default = "default";
          description = "Giants | Klaus";
        };
        fruitfly = mkOption {
          type = types.enum [
            "never"
            "rare"
            "default"
            "often"
            "always"
          ];
          default = "default";
          description = "Giants | Lord of the Fruit Flies";
        };
        malbatross = mkOption {
          type = types.enum [
            "never"
            "rare"
            "default"
            "often"
            "always"
          ];
          default = "default";
          description = "Giants | Malbatross";
        };
        goosemoose = mkOption {
          type = types.enum [
            "never"
            "rare"
            "default"
            "often"
            "always"
          ];
          default = "default";
          description = "Giants | Meese/Geese";
        };
        deciduousmonster = mkOption {
          type = types.enum [
            "never"
            "rare"
            "default"
            "often"
            "always"
          ];
          default = "default";
          description = "Giants | Poison Birchnut Trees";
        };
        spiderqueen = mkOption {
          type = types.enum [
            "never"
            "rare"
            "default"
            "often"
            "always"
          ];
          default = "default";
          description = "Giants | Spider Queen";
        };
        liefs = mkOption {
          type = types.enum [
            "never"
            "rare"
            "default"
            "often"
            "always"
          ];
          default = "default";
          description = "Giants | Treeguards";
        };

        # World Generation Settings
        season_start = mkOption {
          type = types.enum [
            "default"
            "winter"
            "spring"
            "summer"
            "autumn|spring"
            "winter|summer"
            "autumn|winter|spring|summer"
          ];
          default = "default";
          description = "World Generation | Starting Season";
        };
        task_set = mkOption {
          type = types.enum [
            "default"
            "classic"
          ]; # Removed cave_default, quagmire_taskset, lavaarena_taskset as they don't appear in your provided list for task_set
          default = "default";
          description = "World Generation | Biomes";
        };
        start_location = mkOption {
          type = types.enum [
            "plus"
            "darkness"
            "default"
          ]; # Removed lavaarena, quagmire_startlocation, caves as they don't appear in your provided list for start_location
          default = "default";
          description = "World Generation | Spawn Area";
        };
        world_size = mkOption {
          type = types.enum [
            "small"
            "medium"
            "default"
            "huge"
          ];
          default = "default";
          description = "World Generation | World Size";
        };
        branching = mkOption {
          type = types.enum [
            "never"
            "least"
            "default"
            "most"
            "random"
          ];
          default = "default";
          description = "World Generation | Branches";
        };
        loop = mkOption {
          type = types.enum [
            "never"
            "default"
            "always"
          ];
          default = "default";
          description = "World Generation | Loops";
        };
        touchstone = mkOption {
          type = types.enum [
            "never"
            "rare"
            "uncommon"
            "default"
            "often"
            "mostly"
            "always"
            "insane"
          ];
          default = "default";
          description = "World Generation | Touch Stones";
        };
        boons = mkOption {
          type = types.enum [
            "never"
            "rare"
            "uncommon"
            "default"
            "often"
            "mostly"
            "always"
            "insane"
          ];
          default = "default";
          description = "World Generation | Failed Survivors";
        };
        prefabswaps_start = mkOption {
          type = types.enum [
            "classic"
            "default"
            "highly random"
          ];
          default = "default";
          description = "World Generation | Starting Resource Variety";
        };
        moon_fissure = mkOption {
          type = types.enum [
            "never"
            "rare"
            "uncommon"
            "default"
            "often"
            "mostly"
            "always"
            "insane"
          ];
          default = "default";
          description = "World Generation | Celestial Fissures";
        };
        moon_starfish = mkOption {
          type = types.enum [
            "never"
            "rare"
            "uncommon"
            "default"
            "often"
            "mostly"
            "always"
            "insane"
          ];
          default = "default";
          description = "World Generation | Anenemies";
        };
        moon_bullkelp = mkOption {
          type = types.enum [
            "never"
            "rare"
            "uncommon"
            "default"
            "often"
            "mostly"
            "always"
            "insane"
          ];
          default = "default";
          description = "World Generation | Beached Bull Kelp";
        };
        berrybush = mkOption {
          type = types.enum [
            "never"
            "rare"
            "uncommon"
            "default"
            "often"
            "mostly"
            "always"
            "insane"
          ];
          default = "default";
          description = "World Generation | Berry Bushes";
        };
        rock = mkOption {
          type = types.enum [
            "never"
            "rare"
            "uncommon"
            "default"
            "often"
            "mostly"
            "always"
            "insane"
          ];
          default = "default";
          description = "World Generation | Boulders";
        };
        ocean_bullkelp = mkOption {
          type = types.enum [
            "never"
            "rare"
            "uncommon"
            "default"
            "often"
            "mostly"
            "always"
            "insane"
          ];
          default = "default";
          description = "World Generation | Bull Kelp";
        };
        cactus = mkOption {
          type = types.enum [
            "never"
            "rare"
            "uncommon"
            "default"
            "often"
            "mostly"
            "always"
            "insane"
          ];
          default = "default";
          description = "World Generation | Cacti";
        };
        carrot = mkOption {
          type = types.enum [
            "never"
            "rare"
            "uncommon"
            "default"
            "often"
            "mostly"
            "always"
            "insane"
          ];
          default = "default";
          description = "World Generation | Carrots";
        };
        flint = mkOption {
          type = types.enum [
            "never"
            "rare"
            "uncommon"
            "default"
            "often"
            "mostly"
            "always"
            "insane"
          ];
          default = "default";
          description = "World Generation | Flint";
        };
        flowers = mkOption {
          type = types.enum [
            "never"
            "rare"
            "uncommon"
            "default"
            "often"
            "mostly"
            "always"
            "insane"
          ];
          default = "default";
          description = "World Generation | Flowers, Evil Flowers";
        };
        grass = mkOption {
          type = types.enum [
            "never"
            "rare"
            "uncommon"
            "default"
            "often"
            "mostly"
            "always"
            "insane"
          ];
          default = "default";
          description = "World Generation | Grass";
        };
        moon_hotspring = mkOption {
          type = types.enum [
            "never"
            "rare"
            "uncommon"
            "default"
            "often"
            "mostly"
            "always"
            "insane"
          ];
          default = "default";
          description = "World Generation | Hot Springs";
        };
        moon_rock = mkOption {
          type = types.enum [
            "never"
            "rare"
            "uncommon"
            "default"
            "often"
            "mostly"
            "always"
            "insane"
          ];
          default = "default";
          description = "World Generation | Lunar Rocks";
        };
        moon_sapling = mkOption {
          type = types.enum [
            "never"
            "rare"
            "uncommon"
            "default"
            "often"
            "mostly"
            "always"
            "insane"
          ];
          default = "default";
          description = "World Generation | Lunar Saplings";
        };
        moon_tree = mkOption {
          type = types.enum [
            "never"
            "rare"
            "uncommon"
            "default"
            "often"
            "mostly"
            "always"
            "insane"
          ];
          default = "default";
          description = "World Generation | Lune Trees";
        };
        meteorspawner = mkOption {
          type = types.enum [
            "never"
            "rare"
            "uncommon"
            "default"
            "often"
            "mostly"
            "always"
            "insane"
          ];
          default = "default";
          description = "World Generation | Meteor Fields";
        };
        rock_ice = mkOption {
          type = types.enum [
            "never"
            "rare"
            "uncommon"
            "default"
            "often"
            "mostly"
            "always"
            "insane"
          ];
          default = "default";
          description = "World Generation | Mini Glaciers";
        };
        mushroom = mkOption {
          type = types.enum [
            "never"
            "rare"
            "uncommon"
            "default"
            "often"
            "mostly"
            "always"
            "insane"
          ];
          default = "default";
          description = "World Generation | Mushrooms";
        };
        ponds = mkOption {
          type = types.enum [
            "never"
            "rare"
            "uncommon"
            "default"
            "often"
            "mostly"
            "always"
            "insane"
          ];
          default = "default";
          description = "World Generation | Ponds";
        };
        reeds = mkOption {
          type = types.enum [
            "never"
            "rare"
            "uncommon"
            "default"
            "often"
            "mostly"
            "always"
            "insane"
          ];
          default = "default";
          description = "World Generation | Reeds";
        };
        sapling = mkOption {
          type = types.enum [
            "never"
            "rare"
            "uncommon"
            "default"
            "often"
            "mostly"
            "always"
            "insane"
          ];
          default = "default";
          description = "World Generation | Saplings";
        };
        ocean_seastack = mkOption {
          type = types.enum [
            "ocean_never"
            "ocean_rare"
            "ocean_uncommon"
            "ocean_default"
            "ocean_often"
            "ocean_mostly"
            "ocean_always"
            "ocean_insane"
          ];
          default = "ocean_default";
          description = "World Generation | Sea Stacks";
        };
        marshbush = mkOption {
          type = types.enum [
            "never"
            "rare"
            "uncommon"
            "default"
            "often"
            "mostly"
            "always"
            "insane"
          ];
          default = "default";
          description = "World Generation | Spiky Bushes";
        };
        moon_berrybush = mkOption {
          type = types.enum [
            "never"
            "rare"
            "uncommon"
            "default"
            "often"
            "mostly"
            "always"
            "insane"
          ];
          default = "default";
          description = "World Generation | Stone Fruit Bushes";
        };
        trees = mkOption {
          type = types.enum [
            "never"
            "rare"
            "uncommon"
            "default"
            "often"
            "mostly"
            "always"
            "insane"
          ];
          default = "default";
          description = "World Generation | Trees (All)";
        };
        tumbleweed = mkOption {
          type = types.enum [
            "never"
            "rare"
            "uncommon"
            "default"
            "often"
            "mostly"
            "always"
            "insane"
          ];
          default = "default";
          description = "World Generation | Tumbleweeds";
        };
        bees = mkOption {
          type = types.enum [
            "never"
            "rare"
            "uncommon"
            "default"
            "often"
            "mostly"
            "always"
            "insane"
          ];
          default = "default";
          description = "World Generation | Bee Hives";
        };
        beefalo = mkOption {
          type = types.enum [
            "never"
            "rare"
            "uncommon"
            "default"
            "often"
            "mostly"
            "always"
            "insane"
          ];
          default = "default";
          description = "World Generation | Beefalos";
        };
        buzzard = mkOption {
          type = types.enum [
            "never"
            "rare"
            "uncommon"
            "default"
            "often"
            "mostly"
            "always"
            "insane"
          ];
          default = "default";
          description = "World Generation | Buzzards";
        };
        moon_carrot = mkOption {
          type = types.enum [
            "never"
            "rare"
            "uncommon"
            "default"
            "often"
            "mostly"
            "always"
            "insane"
          ];
          default = "default";
          description = "World Generation | Carrats";
        };
        catcoon = mkOption {
          type = types.enum [
            "never"
            "rare"
            "uncommon"
            "default"
            "often"
            "mostly"
            "always"
            "insane"
          ];
          default = "default";
          description = "World Generation | Hollow Stump";
        };
        moles = mkOption {
          type = types.enum [
            "never"
            "rare"
            "uncommon"
            "default"
            "often"
            "mostly"
            "always"
            "insane"
          ];
          default = "default";
          description = "World Generation | Mole Burrows";
        };
        pigs = mkOption {
          type = types.enum [
            "never"
            "rare"
            "uncommon"
            "default"
            "often"
            "mostly"
            "always"
            "insane"
          ];
          default = "default";
          description = "World Generation | Pig Houses";
        };
        rabbits = mkOption {
          type = types.enum [
            "never"
            "rare"
            "uncommon"
            "default"
            "often"
            "mostly"
            "always"
            "insane"
          ];
          default = "default";
          description = "World Generation | Rabbit Holes";
        };
        moon_fruitdragon = mkOption {
          type = types.enum [
            "never"
            "rare"
            "uncommon"
            "default"
            "often"
            "mostly"
            "always"
            "insane"
          ];
          default = "default";
          description = "World Generation | Saladmander";
        };
        ocean_shoal = mkOption {
          type = types.enum [
            "never"
            "rare"
            "uncommon"
            "default"
            "often"
            "mostly"
            "always"
            "insane"
          ];
          default = "default";
          description = "World Generation | Shoals";
        };
        lightninggoat = mkOption {
          type = types.enum [
            "never"
            "rare"
            "uncommon"
            "default"
            "often"
            "mostly"
            "always"
            "insane"
          ];
          default = "default";
          description = "World Generation | Volt Goats";
        };
        ocean_wobsterden = mkOption {
          type = types.enum [
            "never"
            "rare"
            "uncommon"
            "default"
            "often"
            "mostly"
            "always"
            "insane"
          ];
          default = "default";
          description = "World Generation | Wobster Mounds";
        };
        chess = mkOption {
          type = types.enum [
            "never"
            "rare"
            "uncommon"
            "default"
            "often"
            "mostly"
            "always"
            "insane"
          ];
          default = "default";
          description = "World Generation | Clockworks";
        };
        houndmound = mkOption {
          type = types.enum [
            "never"
            "rare"
            "uncommon"
            "default"
            "often"
            "mostly"
            "always"
            "insane"
          ];
          default = "default";
          description = "World Generation | Hound Mounds";
        };
        angrybees = mkOption {
          type = types.enum [
            "never"
            "rare"
            "uncommon"
            "default"
            "often"
            "mostly"
            "always"
            "insane"
          ];
          default = "default";
          description = "World Generation | Killer Bee Hives";
        };
        merm = mkOption {
          type = types.enum [
            "never"
            "rare"
            "uncommon"
            "default"
            "often"
            "mostly"
            "always"
            "insane"
          ];
          default = "default";
          description = "World Generation | Leaky Shack";
        };
        walrus = mkOption {
          type = types.enum [
            "never"
            "rare"
            "uncommon"
            "default"
            "often"
            "mostly"
            "always"
            "insane"
          ];
          default = "default";
          description = "World Generation | MacTusk Camps";
        };
        ocean_waterplant = mkOption {
          type = types.enum [
            "ocean_never"
            "ocean_rare"
            "ocean_uncommon"
            "ocean_default"
            "ocean_often"
            "ocean_mostly"
            "ocean_always"
            "ocean_insane"
          ];
          default = "ocean_default";
          description = "World Generation | Sea Weeds";
        };
        moon_spiders = mkOption {
          type = types.enum [
            "never"
            "rare"
            "uncommon"
            "default"
            "often"
            "mostly"
            "always"
            "insane"
          ];
          default = "default";
          description = "World Generation | Shattered Spider Holes";
        };
        spiders = mkOption {
          type = types.enum [
            "never"
            "rare"
            "uncommon"
            "default"
            "often"
            "mostly"
            "always"
            "insane"
          ];
          default = "default";
          description = "World Generation | Spider Dens";
        };
        tallbirds = mkOption {
          type = types.enum [
            "never"
            "rare"
            "uncommon"
            "default"
            "often"
            "mostly"
            "always"
            "insane"
          ];
          default = "default";
          description = "World Generation | Tallbirds";
        };
        tentacles = mkOption {
          type = types.enum [
            "never"
            "rare"
            "uncommon"
            "default"
            "often"
            "mostly"
            "always"
            "insane"
          ];
          default = "default";
          description = "World Generation | Tentacles";
        };
      };
    }
  );
}
