#define MAX_SUMO_SPAWN_LOCS 5
#define MAX_SUMO_VEH_SPAWN_LOCS 11
#define MAX_SUMO_VEHCLES 146

enum ESUMO_SPAWN_LOCATIONS {
    Float:SUMO_POSX,
    Float:SUMO_POSY,
    Float:SUMO_POSZ
}

new SUMO_SPAWN_LOCATIONS[][ESUMO_SPAWN_LOCATIONS] = {
    { 2824.4834, 919.9783, 10.7500 },
    { 2801.9421, 919.4294, 10.7500 },
    { 2807.2361, 960.6561, 10.7500 },
    { 2839.8350, 960.7062, 10.7500 },
    { 2842.8335, 1009.1552, 10.7500 }
};

new SUMO_VEH_SPAWN_LOCATIONS[][ESUMO_SPAWN_LOCATIONS] = {
    { 3267.5066, 1079.3928, 84.3541 },
    { 3310.8896, 936.0820, 83.7306 },
    { 3163.2434, 898.6959, 84.2129 },
    { 3129.4436, 1028.4930, 84.1176 },
    { 3225.2747, 966.1530, 92.0568 },
    { 3162.4290, 1102.1166, 110.0555 },
    { 3210.2410, 1013.3697, 123.7460 },
    { 3235.1829, 963.6337, 123.7458 },
    { 3291.9563, 864.2275, 109.4573 },
    { 3322.4583, 1067.6451, 109.8855 },
    { 3109.1975, 910.3992, 109.8354 }
};

new SUMO_VEHCLES[] = {
    400,
    401,
    402,
    404,
    405,
    409,
    410,
    411,
    412,
    413,
    415,
    416,
    418,
    419,
    420,
    421,
    422,
    423,
    424,
    426,
    429,
    434,
    436,
    438,
    439,
    440,
    442,
    445,
    451,
    457,
    458,
    459,
    466,
    467,
    470,
    471,
    474,
    475,
    477,
    478,
    479,
    480,
    482,
    483,
    485,
    489,
    490,
    492,
    494,
    495,
    496,
    500,
    502,
    503,
    504,
    505,
    506,
    507,
    516,
    517,
    518,
    525,
    526,
    527,
    528,
    529,
    530,
    531,
    532,
    533,
    534,
    535,
    536,
    540,
    541,
    542,
    543,
    545,
    546,
    547,
    549,
    550,
    551,
    552,
    554,
    555,
    558,
    559,
    560,
    561,
    562,
    565,
    566,
    567,
    568,
    571,
    572,
    574,
    575,
    576,
    579,
    580,
    582,
    583,
    585,
    587,
    589,
    596,
    597,
    598,
    599,
    600,
    602,
    603,
    604,
    605,
    609,
    403,
    406,
    407,
    408,
    414,
    427,
    428,
    431,
    432,
    433,
    437,
    443,
    444,
    455,
    456,
    486,
    498,
    499,
    508,
    514,
    515,
    524,
    544,
    556,
    557,
    573,
    578,
    588,
    601
};