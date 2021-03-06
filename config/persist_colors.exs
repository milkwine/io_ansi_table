use Mix.Config

config :io_ansi_table,
  color_codes: %{
    maroon: 1,
    japanese_laurel: 2,
    navy: 4,
    fresh_eggplant: 5,
    teal: 6,
    lime: 10,
    stratos: 17,
    dark_blue: 18,
    medium_blue: 20,
    dark_green: 22,
    dark_slate_gray: 23,
    mosque: 23,
    blue_lagoon: 24,
    cobalt: 25,
    navy_blue: 26,
    blue_ribbon: 27,
    deep_sea: 29,
    dark_cyan: 30,
    cerulean: 31,
    pacific_blue: 32,
    dodger_blue: 33,
    islamic_green: 34,
    jade: 35,
    persian_green: 36,
    bondi_blue: 37,
    light_sea_green: 37,
    iris_blue: 38,
    deep_sky_blue: 39,
    malachite: 41,
    caribbean_green: 42,
    dark_turquoise: 44,
    spring_green: 48,
    medium_spring_green: 49,
    bright_turquoise: 50,
    aqua: 51,
    rosewood: 52,
    tyrian_purple: 53,
    indigo: 54,
    electric_indigo: 56,
    blue_violet: 57,
    verdun_green: 58,
    dim_gray: 59,
    kimberly: 60,
    rich_blue: 61,
    slate_blue: 62,
    neon_blue: 63,
    royal_blue: 63,
    limeade: 64,
    hippie_green: 65,
    hoki: 66,
    air_force_blue: 67,
    steel_blue: 67,
    picton_blue: 68,
    cornflower_blue: 69,
    light_slate_blue: 69,
    fern: 71,
    cadet_blue: 72,
    keppel: 72,
    fountain_blue: 73,
    shakespeare: 74,
    maya_blue: 75,
    bright_green: 76,
    pastel_green: 78,
    medium_turquoise: 80,
    malibu: 81,
    screamin_green: 83,
    baby_blue: 87,
    dark_red: 88,
    eggplant: 89,
    dark_magenta: 90,
    dark_violet: 92,
    purple: 93,
    brown: 94,
    light_wood: 95,
    trendy_pink: 96,
    blue_marguerite: 97,
    heliotrope: 99,
    olive: 100,
    bandicoot: 101,
    light_slate_grey: 103,
    ship_cove: 103,
    medium_purple: 104,
    portage: 104,
    citrus: 106,
    chelsea_cucumber: 107,
    dark_sea_green: 108,
    ziggurat: 109,
    seagull: 110,
    lawn_green: 112,
    gossip: 114,
    bermuda: 115,
    riptide: 116,
    columbia_blue: 117,
    chartreuse: 118,
    mint_green: 120,
    pale_green: 121,
    electric_blue: 123,
    free_speech_red: 124,
    flirt: 125,
    medium_violet_red: 126,
    deep_magenta: 127,
    electric_violet: 128,
    electric_purple: 129,
    tenne: 130,
    rose_of_sharon: 130,
    coral_tree: 131,
    tapestry: 132,
    violet_blue: 133,
    medium_orchid: 134,
    dark_goldenrod: 136,
    teak: 137,
    rosy_brown: 138,
    thatch: 138,
    london_hue: 139,
    wisteria: 140,
    buddha_gold: 142,
    dark_khaki: 143,
    olive_green: 143,
    neutral_green: 144,
    dark_gray: 145,
    moon_raker: 146,
    light_steel_blue: 147,
    spring_bud: 148,
    conifer: 149,
    feijoa: 150,
    chinook: 151,
    scandal: 152,
    anakiwa: 153,
    green_yellow: 154,
    aero_blue: 158,
    french_pass: 159,
    guardsman_red: 160,
    razzmatazz: 161,
    hollywood_cerise: 162,
    purple_pizzazz: 164,
    psychedelic_purple: 165,
    tenn: 166,
    indian_red: 167,
    roman: 167,
    pale_violet_red: 168,
    hopbush: 169,
    orchid: 170,
    heliotrope: 171,
    chocolate: 172,
    mango_tango: 172,
    copper: 173,
    my_pink: 174,
    kobi: 175,
    plum: 176,
    violet: 177,
    corn: 178,
    golden_poppy: 178,
    goldenrod: 178,
    equator: 179,
    calico: 180,
    tan: 180,
    pink_flare: 181,
    french_lilac: 182,
    mauve: 183,
    school_bus_yellow: 184,
    tacha: 185,
    deco: 186,
    aths_special: 187,
    light_gray: 188,
    light_grey: 188,
    lavender_blue: 189,
    chartreuse_yellow: 190,
    laser_lemon: 191,
    canary: 192,
    reef: 193,
    beige: 194,
    honeydew: 194,
    oyster_bay: 195,
    rose: 197,
    deep_pink: 198,
    hot_magenta: 200,
    fuchsia: 201,
    orange_red: 202,
    safety_orange: 202,
    bittersweet: 203,
    wild_watermelon: 204,
    hot_pink: 205,
    neon_pink: 206,
    pink_flamingo: 207,
    dark_orange: 208,
    coral: 209,
    light_coral: 210,
    mona_lisa: 210,
    tickle_me_pink: 211,
    fuchsia_pink: 213,
    orange: 214,
    rajah: 215,
    sandy_brown: 215,
    macaroni_and_cheese: 216,
    melon: 217,
    cotton_candy: 218,
    lavender_rose: 219,
    gold: 220,
    dandelion: 221,
    khaki: 222,
    salomie: 222,
    moccasin: 223,
    navajo_white: 223,
    mysty_rose: 224,
    lavender_blush: 225,
    dolly: 228,
    portafino: 229,
    cream: 230,
    cumulus: 230,
    cod_gray: 232,
    nero: 234,
    mine_shaft: 235,
    night_rider: 236,
    eclipse: 237,
    charcoal: 238,
    tundora: 238,
    matterhorn: 239,
    mortar: 240,
    scorpion: 240,
    dove_gray: 241,
    empress: 243,
    gray: 244,
    grey: 244,
    suva_grey: 245,
    dusty_gray: 246,
    silver_chalice: 247,
    silver: 250,
    alto: 252,
    gainsboro: 254,
    mercury: 254,
    gallery: 255,
    white_smoke: 255
  }
