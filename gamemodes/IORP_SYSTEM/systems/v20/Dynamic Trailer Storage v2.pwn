// this script use static vehicle systemm, and many function are crossed both script cause of integration
// integrated scripts: static vehicle, material item list

#define STATIC_VEHICLE_TABLE "staticVehicles"
enum TrailerStorage:EnumData {
    TrailerStorage:Name[50],
        TrailerStorage:limit,
        TrailerStorage:itemId
}
new TrailerStorage:Data[MAXTRAILERITEMS][TrailerStorage:EnumData] = {
    { "Corn", 1000, 0 }, // 
    { "Wheat", 1000, 1 }, // 
    { "Onion", 1000, 2 }, // 
    { "Potato", 1000, 3 }, // 
    { "Garlic", 1000, 4 }, // 
    { "Vinegar", 1000, 5 }, // 
    { "Tomato", 1000, 6 }, // 
    { "Rice", 1000, 7 }, // 
    { "Corn_Seed", 1000, 8 }, // 
    { "Wheat_Seed", 1000, 9 }, // 
    { "Onion_Seed", 1000, 10 }, // 
    { "Potato_Seed", 1000, 11 }, // 
    { "Garlic_Seed", 1000, 12 }, // 
    { "Vinegar_Seed", 1000, 13 }, // 
    { "Tomato_Seed", 1000, 14 }, // 
    { "Rice_Seed", 1000, 15 }, // 
    { "Water", 1000, 16 }, // 
    { "Meet", 1000, 17 }, // 
    { "Milk", 1000, 18 }, // 
    { "Cheese", 1000, 19 }, // 
    { "Egg", 1000, 20 }, // 
    { "Glass", 1000, 21 }, // 
    { "Aluminium", 1000, 22 }, // 
    { "Rubber", 1000, 23 }, // 
    { "MicroFiber", 1000, 24 }, // 
    { "Copper", 1000, 25 }, // 
    { "Amethyst", 1000, 26 }, // 
    { "Emerald", 1000, 27 }, // 
    { "Ruby", 1000, 28 }, // 
    { "Saphhire", 1000, 29 }, // 
    { "Gold", 1000, 30 }, // 
    { "Wood", 1000, 31 }, // 
    { "Alexa_Kit", 50, 32 }, // 
    { "Auto_Drive_Kit", 50, 33 }, // 
    { "GPS", 50, 34 }, // 
    { "MP3", 50, 35 }, // 
    { "Personal_Radio", 50, 36 }, // 
    { "Phone", 50, 37 }, // 
    { "Tablet", 50, 38 }, // 
    { "Oral_Antihistamines", 50, 39 }, // 
    { "Ditropan_XL", 50, 40 }, // 
    { "Benzodiazepines", 50, 41 }, // 
    { "Naproxen", 50, 42 }, // 
    { "Bismuth_subsalicylate", 50, 43 }, // 
    { "Noisy_Firecrackers", 50, 44 }, // 
    { "Light_Firecrackers", 50, 45 }, // 
    { "Smoke_Grenade", 50, 46 }, // 
    { "Single_Rocket", 50, 47 }, // 
    { "Knuckle_Duster", 50, 48 }, // 
    { "Golf_Club", 50, 49 }, // 
    { "Baton", 50, 50 }, // 
    { "Knife", 50, 51 }, // 
    { "Baseball_Bat", 50, 52 }, // 
    { "Spade", 50, 53 }, // 
    { "Pool_Cue", 50, 54 }, // 
    { "Sword", 50, 55 }, // 
    { "Chainsaw", 50, 56 }, // 
    { "Cane", 50, 57 }, // 
    { "Grenade", 50, 58 }, // 
    { "Teargas", 50, 59 }, // 
    { "Molotov", 50, 60 }, // 
    { "M9", 500, 61 }, // 
    { "M9_SD", 500, 62 }, // 
    { "Desert_Eagle", 500, 63 }, // 
    { "Shotgun", 500, 64 }, // 
    { "Sawnoff", 500, 65 }, // 
    { "Spas_12", 500, 66 }, // 
    { "Mac_10", 500, 67 }, // 
    { "MP5", 500, 68 }, // 
    { "AK-47", 500, 69 }, // 
    { "M16", 500, 70 }, // 
    { "Tec_9", 500, 71 }, // 
    { "Rifle", 500, 72 }, // 
    { "Sniper", 200, 73 }, // 
    { "RPG", 200, 74 }, // 
    { "Heatseeker", 500, 75 }, // 
    { "Flamer", 500, 76 }, // 
    { "Spray_Paint", 20, 77 }, // 
    { "Extinguisher", 20, 78 }, // 
    { "Camera", 20, 79 }, // 
    { "Parachute", 20, 80 }, // 
    { "Dildo_1", 20, 81 }, // 
    { "Dildo_2", 20, 82 }, // 
    { "Dildo_3", 20, 83 }, // 
    { "Dildo_4", 20, 84 }, // 
    { "Flowers", 20, 85 }, // 
    { "The_Truth", 5, 86 }, // 
    { "Maccer", 5, 87 }, // 
    { "Andre", 5, 88 }, // 
    { "Big_Bear_Thorne_[Thin]", 5, 89 }, // 
    { "Big_Bear_Thorne_[Big]", 5, 90 }, // 
    { "Emmet", 5, 91 }, // 
    { "Taxi_Driver_2/Train_Driver", 5, 92 }, // 
    { "Janitor", 5, 93 }, // 
    { "Normal_Ped_2", 5, 94 }, // 
    { "Old_Woman", 5, 95 }, // 
    { "Casino_croupier", 5, 96 }, // 
    { "Rich_Woman_2", 5, 97 }, // 
    { "Street_Girl", 5, 98 }, // 
    { "Normal_Ped_3", 5, 99 }, // 
    { "Mr.Whittaker_(RS_Haul_Owner)", 5, 100 }, // 
    { "Businessman_1", 5, 101 }, // 
    { "Beach_Visitor_2", 5, 102 }, // 
    { "DJ", 5, 103 }, // 
    { "Rich_Guy_(Madd_Dogg's_Manager)", 5, 104 }, // 
    { "Normal_Ped_4", 5, 105 }, // 
    { "Normal_Ped_5", 5, 106 }, // 
    { "BMXer", 5, 107 }, // 
    { "Madd_Dogg_Bodyguard_1", 5, 108 }, // 
    { "Madd_Dogg_Bodyguard_2", 5, 109 }, // 
    { "Backpacker", 5, 110 }, // 
    { "Drug_Dealer_1", 5, 111 }, // 
    { "Drug_Dealer_2", 5, 112 }, // 
    { "Drug_Dealer_3", 5, 113 }, // 
    { "Farm-Town_inhabitant_1", 5, 114 }, // 
    { "Farm-Town_inhabitant_2", 5, 115 }, // 
    { "Farm-Town_inhabitant_3", 5, 116 }, // 
    { "Farm-Town_inhabitant_4", 5, 117 }, // 
    { "Gardener", 5, 118 }, // 
    { "Golfer_0", 5, 119 }, // 
    { "Golfer_1", 5, 120 }, // 
    { "Normal_Ped_1", 5, 121 }, // 
    { "Normal_Ped_6", 5, 122 }, // 
    { "Normal_Ped_7", 5, 123 }, // 
    { "Normal_Ped_8", 5, 124 }, // 
    { "Jethro", 5, 125 }, // 
    { "Normal_Ped_9", 5, 126 }, // 
    { "Normal_Ped_10", 5, 127 }, // 
    { "Beach_Visitor_3", 5, 128 }, // 
    { "Normal_Ped_11", 5, 129 }, // 
    { "Normal_Ped_12", 5, 130 }, // 
    { "Normal_Ped_13", 5, 131 }, // 
    { "Snakehead_(Da_Nang)", 5, 132 }, // 
    { "Mechanic", 5, 133 }, // 
    { "Mountain_Biker", 5, 134 }, // 
    { "Mountain_Biker", 5, 135 }, // 
    { "Unknown", 5, 136 }, // 
    { "Normal_Ped_14", 5, 137 }, // 
    { "Normal_Ped_15", 5, 138 }, // 
    { "Normal_Ped_16", 5, 139 }, // 
    { "Oriental_Ped_2", 5, 140 }, // 
    { "Oriental_Ped_3", 5, 141 }, // 
    { "Normal_Ped_17", 5, 142 }, // 
    { "Normal_Ped_18", 5, 143 }, // 
    { "Colonel_Fuhrberger", 5, 144 }, // 
    { "Prostitute_1", 5, 145 }, // 
    { "Prostitute_2", 5, 146 }, // 
    { "Kendl_Johnson", 5, 147 }, // 
    { "Pool_Player", 5, 148 }, // 
    { "Pool_Player", 5, 149 }, // 
    { "Priest/Preacher", 5, 150 }, // 
    { "Normal_Ped_19", 5, 151 }, // 
    { "Hippy_1", 5, 152 }, // 
    { "Hippy_2", 5, 153 }, // 
    { "Prostitute_3", 5, 154 }, // 
    { "Stewardess", 5, 155 }, // 
    { "Homeless_1", 5, 156 }, // 
    { "Homeless_2", 5, 157 }, // 
    { "Homeless_3", 5, 158 }, // 
    { "Boxer_1", 5, 159 }, // 
    { "Boxer_2", 5, 160 }, // 
    { "Black_Elvis", 5, 161 }, // 
    { "White_Elvis", 5, 162 }, // 
    { "Blue_Elvis", 5, 163 }, // 
    { "Prostitute_4", 5, 164 }, // 
    { "Ryder_with_robbery_mask", 5, 165 }, // 
    { "Stripper_2", 5, 166 }, // 
    { "Normal_Ped_20", 5, 167 }, // 
    { "Normal_Ped_21", 5, 168 }, // 
    { "Jogger_2", 5, 169 }, // 
    { "Rich_Woman_1", 5, 170 }, // 
    { "Rollerskater", 5, 171 }, // 
    { "Normal_Ped_22", 5, 172 }, // 
    { "Normal_Ped_23", 5, 173 }, // 
    { "Normal_Ped_24", 5, 174 }, // 
    { "Jogger_1", 5, 175 }, // 
    { "Lifeguard_2", 5, 176 }, // 
    { "Normal_Ped_25", 5, 177 }, // 
    { "Rollerskater", 5, 178 }, // 
    { "Biker_2", 5, 179 }, // 
    { "Normal_Ped_26", 5, 180 }, // 
    { "Balla_1", 5, 181 }, // 
    { "Balla_2", 5, 182 }, // 
    { "Balla_3", 5, 183 }, // 
    { "Grove_Street_Families_1", 5, 184 }, // 
    { "Grove_Street_Families_2", 5, 185 }, // 
    { "Grove_Street_Families_3", 5, 186 }, // 
    { "Los_Santos_Vagos_1", 5, 187 }, // 
    { "Los_Santos_Vagos_2", 5, 188 }, // 
    { "Los_Santos_Vagos_3", 5, 189 }, // 
    { "The_Russian_Mafia_1", 5, 190 }, // 
    { "The_Russian_Mafia_2", 5, 191 }, // 
    { "The_Russian_Mafia_3", 5, 192 }, // 
    { "Varios_Los_Aztecas_1", 5, 193 }, // 
    { "Varios_Los_Aztecas_2", 5, 194 }, // 
    { "Varios_Los_Aztecas_3", 5, 195 }, // 
    { "Triad_0", 5, 196 }, // 
    { "Triad_1", 5, 197 }, // 
    { "Johhny_Sindacco", 5, 198 }, // 
    { "Triad_Boss", 5, 199 }, // 
    { "Da_Nang_Boy_1", 5, 200 }, // 
    { "Da_Nang_Boy_2", 5, 201 }, // 
    { "Da_Nang_Boy_3", 5, 202 }, // 
    { "The_Mafia_1", 5, 203 }, // 
    { "The_Mafia_2", 5, 204 }, // 
    { "The_Mafia_3", 5, 205 }, // 
    { "The_Mafia_4", 5, 206 }, // 
    { "Farm_Inhabitant_1", 5, 207 }, // 
    { "Farm_Inhabitant_2", 5, 208 }, // 
    { "Farm_Inhabitant_3", 5, 209 }, // 
    { "Farm_Inhabitant_4", 5, 210 }, // 
    { "Farm_Inhabitant_5", 5, 211 }, // 
    { "Farm_Inhabitant_6", 5, 212 }, // 
    { "Homeless_1", 5, 213 }, // 
    { "Homeless_2", 5, 214 }, // 
    { "Normal_Ped_27", 5, 215 }, // 
    { "Homeless_2", 5, 216 }, // 
    { "Beach_Visitor_1", 5, 217 }, // 
    { "Beach_Visitor_4", 5, 218 }, // 
    { "Beach_Visitor_5", 5, 219 }, // 
    { "Businesswoman_1", 5, 220 }, // 
    { "Taxi_Driver_1", 5, 221 }, // 
    { "Crack_Maker_1", 5, 222 }, // 
    { "Crack_Maker_2", 5, 223 }, // 
    { "Crack_Maker_3", 5, 224 }, // 
    { "Crack_Maker_4", 5, 225 }, // 
    { "Businessman", 5, 226 }, // 
    { "Businesswoman_2", 5, 227 }, // 
    { "Big_Smoke_Armored", 5, 228 }, // 
    { "Businesswoman_3", 5, 229 }, // 
    { "Normal_Ped_28", 5, 230 }, // 
    { "Prostitute_5", 5, 231 }, // 
    { "Construction_Worker", 5, 232 }, // 
    { "Beach_Visitor_6", 5, 233 }, // 
    { "Barber_2", 5, 234 }, // 
    { "Hillbilly_2", 5, 235 }, // 
    { "Farmer_1", 5, 236 }, // 
    { "Hillbilly_1", 5, 237 }, // 
    { "Hillbilly_3", 5, 238 }, // 
    { "Farmer_2", 5, 239 }, // 
    { "Hillbilly_4", 5, 240 }, // 
    { "Black_Bouncer", 5, 241 }, // 
    { "White_Bouncer", 5, 242 }, // 
    { "White_MIB_agent", 5, 243 }, // 
    { "Black_MIB_agent", 5, 244 }, // 
    { "Cluckin'_Bell_Worker", 5, 245 }, // 
    { "Hotdog/Chilli_Dog_Vendor", 5, 246 }, // 
    { "Normal_Ped_29", 5, 247 }, // 
    { "Normal_Ped_30", 5, 248 }, // 
    { "Blackjack_Dealer", 5, 249 }, // 
    { "Casino_croupier", 5, 250 }, // 
    { "San_Fierro_Rifa", 5, 251 }, // 
    { "San_Fierro_Rifa", 5, 252 }, // 
    { "San_Fierro_Rifa", 5, 253 }, // 
    { "Barber_1", 5, 254 }, // 
    { "Barber_3", 5, 255 }, // 
    { "Whore", 5, 256 }, // 
    { "Ammunation_Salesman", 5, 257 }, // 
    { "Tattoo_Artist", 5, 258 }, // 
    { "Punk", 5, 259 }, // 
    { "Cab_Driver_1", 5, 260 }, // 
    { "Normal_Ped_31", 5, 261 }, // 
    { "Normal_Ped_32", 5, 262 }, // 
    { "Normal_Ped_33", 5, 263 }, // 
    { "Normal_Ped_34", 5, 264 }, // 
    { "Businessman", 5, 265 }, // 
    { "Normal_Ped_35", 5, 266 }, // 
    { "Valet", 5, 267 }, // 
    { "Barbara_Schternvart", 5, 268 }, // 
    { "Helena_Wankstein", 5, 269 }, // 
    { "Michelle_Cannes", 5, 270 }, // 
    { "Katie_Zhan", 5, 271 }, // 
    { "Millie_Perkins", 5, 272 }, // 
    { "Denise_Robinson", 5, 273 }, // 
    { "Farm-Town_inhabitant", 5, 274 }, // 
    { "Hillbilly_5", 5, 275 }, // 
    { "Farm-Town_inhabitant", 5, 276 }, // 
    { "Farm-Town_inhabitant", 5, 277 }, // 
    { "Hillbilly_6", 5, 278 }, // 
    { "Farmer_3", 5, 279 }, // 
    { "Farmer_4", 5, 280 }, // 
    { "Karate_Teacher", 5, 281 }, // 
    { "Karate_Teacher", 5, 282 }, // 
    { "Cab_Driver_2", 5, 283 }, // 
    { "Prostitute_6", 5, 284 }, // 
    { "Su_Xi_Mu_(Suzie)", 5, 285 }, // 
    { "Oriental_Noodle_stand_vendor", 5, 286 }, // 
    { "Oriental_Boating_School_Instructor", 5, 287 }, // 
    { "Clothes_shop_staff", 5, 288 }, // 
    { "Homeless_3", 5, 289 }, // 
    { "Weird_old_man", 5, 290 }, // 
    { "Waitress_(Maria_Latore)", 5, 291 }, // 
    { "Normal_Ped_36", 5, 292 }, // 
    { "Normal_Ped_37", 5, 293 }, // 
    { "Clothes_shop_staff", 5, 294 }, // 
    { "Normal_Ped_38", 5, 295 }, // 
    { "Rich_Woman_3", 5, 296 }, // 
    { "Cab_Driver_3", 5, 297 }, // 
    { "Normal_Ped_39", 5, 298 }, // 
    { "Normal_Ped_40", 5, 299 }, // 
    { "Normal_Ped_41", 5, 300 }, // 
    { "Normal_Ped_42", 5, 301 }, // 
    { "Normal_Ped_43", 5, 302 }, // 
    { "Normal_Ped_44", 5, 303 }, // 
    { "Oriental_Businessman", 5, 304 }, // 
    { "Oriental_Ped_1", 5, 305 }, // 
    { "Oriental_Ped_4", 5, 306 }, // 
    { "Homeless_4", 5, 307 }, // 
    { "Normal_Ped_45", 5, 308 }, // 
    { "Normal_Ped_46", 5, 309 }, // 
    { "Normal_Ped_47", 5, 310 }, // 
    { "Cab_Driver_4", 5, 311 }, // 
    { "Normal_Ped_48", 5, 312 }, // 
    { "Normal_Ped_49", 5, 313 }, // 
    { "Prostitute_7", 5, 314 }, // 
    { "Prostitute_8", 5, 315 }, // 
    { "Homeless_1", 5, 316 }, // 
    { "The_D.A", 5, 317 }, // 
    { "Afro-American", 5, 318 }, // 
    { "Mexican", 5, 319 }, // 
    { "Prostitute_9", 5, 320 }, // 
    { "Stripper_3", 5, 321 }, // 
    { "Prostitute_10", 5, 322 }, // 
    { "Stripper_4", 5, 323 }, // 
    { "Biker_3", 5, 324 }, // 
    { "Biker_1", 5, 325 }, // 
    { "Pimp", 5, 326 }, // 
    { "Normal_Ped_50", 5, 327 }, // 
    { "Lifeguard_1", 5, 328 }, // 
    { "Naked_Valet", 5, 329 }, // 
    { "Biker_Drug_Dealer", 5, 330 }, // 
    { "Chauffeur_(Limo_Driver)", 5, 331 }, // 
    { "Stripper_1", 5, 332 }, // 
    { "Stripper_5", 5, 333 }, // 
    { "Heckler_1", 5, 334 }, // 
    { "Heckler_2", 5, 335 }, // 
    { "Cab_driver_5", 5, 336 }, // 
    { "Cab_driver_6", 5, 337 }, // 
    { "Normal_Ped_51", 5, 338 }, // 
    { "Clown_(Ice-cream_Van_Driver)", 5, 339 }, // 
    { "Dwaine/Dwayne", 5, 340 }, // 
    { "Melvin_Big_Smoke_Harris_(Mission)", 5, 341 }, // 
    { "Sean_'Sweet'_Johnson", 5, 342 }, // 
    { "Lance_'Ryder'_Wilson", 5, 343 }, // 
    { "Mafia_Boss", 5, 344 }, // 
    { "T-Bone_Mendez", 5, 345 }, // 
    { "Zero", 5, 346 }, // 
    { "Ken_Rosenberg", 5, 347 }, // 
    { "Kent_Paul", 5, 348 }, // 
    { "Cesar_Vialpando", 5, 349 }, // 
    { "Jeffery_OG_Loc_Martin/Cross", 5, 350 }, // 
    { "Wu_Zi_Mu_(Woozie)", 5, 351 }, // 
    { "Michael_Toreno_(Mike)", 5, 352 }, // 
    { "Jizzy_B.", 5, 353 }, // 
    { "Madd_Dogg", 5, 354 }, // 
    { "Catalina", 5, 355 }, // 
    { "Claude_Speed", 5, 356 }, // 
    { "Landstalker", 1, 357 }, // 
    { "Bravura", 1, 358 }, // 
    { "Buffalo", 1, 359 }, // 
    { "Linerunner", 1, 360 }, // 
    { "Perrenial", 1, 361 }, // 
    { "Sentinel", 1, 362 }, // 
    { "Dumper", 1, 363 }, // 
    { "Firetruck", 1, 364 }, // 
    { "Trashmaster", 1, 365 }, // 
    { "Stretch", 1, 366 }, // 
    { "Manana", 1, 367 }, // 
    { "Infernus", 1, 368 }, // 
    { "Voodoo", 1, 369 }, // 
    { "Pony", 1, 370 }, // 
    { "Mule", 1, 371 }, // 
    { "Cheetah", 1, 372 }, // 
    { "Ambulance", 1, 373 }, // 
    { "Leviathan", 1, 374 }, // 
    { "Moonbeam", 1, 375 }, // 
    { "Esperanto", 1, 376 }, // 
    { "Taxi", 1, 377 }, // 
    { "Washington", 1, 378 }, // 
    { "Bobcat", 1, 379 }, // 
    { "Mr_Whoopee", 1, 380 }, // 
    { "BF_Injection", 1, 381 }, // 
    { "Hunter", 1, 382 }, // 
    { "Premier", 1, 383 }, // 
    { "Enforcer", 1, 384 }, // 
    { "Securicar", 1, 385 }, // 
    { "Banshee", 1, 386 }, // 
    { "Predator", 1, 387 }, // 
    { "Bus", 1, 388 }, // 
    { "Rhino", 1, 389 }, // 
    { "Barracks", 1, 390 }, // 
    { "Hotknife", 1, 391 }, // 
    { "Trailer_1", 1, 392 }, // 
    { "Previon", 1, 393 }, // 
    { "Coach", 1, 394 }, // 
    { "Cabbie", 1, 395 }, // 
    { "Stallion", 1, 396 }, // 
    { "Rumpo", 1, 397 }, // 
    { "RC_Bandit", 1, 398 }, // 
    { "Romero", 1, 399 }, // 
    { "Packer", 1, 400 }, // 
    { "Monster", 1, 401 }, // 
    { "Admiral", 1, 402 }, // 
    { "Squalo", 1, 403 }, // 
    { "Seasparrow", 1, 404 }, // 
    { "Pizzaboy", 1, 405 }, // 
    { "Tram", 1, 406 }, // 
    { "Trailer_2", 1, 407 }, // 
    { "Turismo", 1, 408 }, // 
    { "Speeder", 1, 409 }, // 
    { "Reefer", 1, 410 }, // 
    { "Tropic", 1, 411 }, // 
    { "Flatbed", 1, 412 }, // 
    { "Yankee", 1, 413 }, // 
    { "Caddy", 1, 414 }, // 
    { "Solair", 1, 415 }, // 
    { "Berkley's_RC_Van", 1, 416 }, // 
    { "Skimmer", 1, 417 }, // 
    { "PCJ-600", 1, 418 }, // 
    { "Faggio", 1, 419 }, // 
    { "Freeway", 1, 420 }, // 
    { "RC_Baron", 1, 421 }, // 
    { "RC_Raider", 1, 422 }, // 
    { "Glendale", 1, 423 }, // 
    { "Oceanic", 1, 424 }, // 
    { "Sanchez", 1, 425 }, // 
    { "Sparrow", 1, 426 }, // 
    { "Patriot", 1, 427 }, // 
    { "Quad", 1, 428 }, // 
    { "Coastguard", 1, 429 }, // 
    { "Dinghy", 1, 430 }, // 
    { "Hermes", 1, 431 }, // 
    { "Sabre", 1, 432 }, // 
    { "Rustler", 1, 433 }, // 
    { "ZR-350", 1, 434 }, // 
    { "Walton", 1, 435 }, // 
    { "Regina", 1, 436 }, // 
    { "Comet", 1, 437 }, // 
    { "BMX", 1, 438 }, // 
    { "Burrito", 1, 439 }, // 
    { "Camper", 1, 440 }, // 
    { "Marquis", 1, 441 }, // 
    { "Baggage", 1, 442 }, // 
    { "Dozer", 1, 443 }, // 
    { "Maverick", 1, 444 }, // 
    { "News_Chopper", 1, 445 }, // 
    { "Rancher", 1, 446 }, // 
    { "FBI_Rancher", 1, 447 }, // 
    { "Virgo", 1, 448 }, // 
    { "Greenwood", 1, 449 }, // 
    { "Jetmax", 1, 450 }, // 
    { "Hotring", 1, 451 }, // 
    { "Sandking", 1, 452 }, // 
    { "Blista_Compact", 1, 453 }, // 
    { "Police_Maverick", 1, 454 }, // 
    { "Boxville", 1, 455 }, // 
    { "Benson", 1, 456 }, // 
    { "Mesa", 1, 457 }, // 
    { "RC_Goblin", 1, 458 }, // 
    { "Hotring_Racer_A", 1, 459 }, // 
    { "Hotring_Racer_B", 1, 460 }, // 
    { "Bloodring_Banger", 1, 461 }, // 
    { "Rancher", 1, 462 }, // 
    { "Super_GT", 1, 463 }, // 
    { "Elegant", 1, 464 }, // 
    { "Journey", 1, 465 }, // 
    { "Bike", 1, 466 }, // 
    { "Mountain_Bike", 1, 467 }, // 
    { "Beagle", 1, 468 }, // 
    { "Cropdust", 1, 469 }, // 
    { "Stunt", 1, 470 }, // 
    { "Tanker", 1, 471 }, // 
    { "Roadtrain", 1, 472 }, // 
    { "Nebula", 1, 473 }, // 
    { "Majestic", 1, 474 }, // 
    { "Buccaneer", 1, 475 }, // 
    { "Shamal", 1, 476 }, // 
    { "Hydra", 1, 477 }, // 
    { "FCR-900", 1, 478 }, // 
    { "NRG-500", 1, 479 }, // 
    { "HPV1000", 1, 480 }, // 
    { "Cement_Truck", 1, 481 }, // 
    { "Tow_Truck", 1, 482 }, // 
    { "Fortune", 1, 483 }, // 
    { "Cadrona", 1, 484 }, // 
    { "FBI_Truck", 1, 485 }, // 
    { "Willard", 1, 486 }, // 
    { "Forklift", 1, 487 }, // 
    { "Tractor", 1, 488 }, // 
    { "Combine", 1, 489 }, // 
    { "Feltzer", 1, 490 }, // 
    { "Remington", 1, 491 }, // 
    { "Slamvan", 1, 492 }, // 
    { "Blade", 1, 493 }, // 
    { "Freight", 1, 494 }, // 
    { "Streak", 1, 495 }, // 
    { "Vortex", 1, 496 }, // 
    { "Vincent", 1, 497 }, // 
    { "Bullet", 1, 498 }, // 
    { "Clover", 1, 499 }, // 
    { "Sadler", 1, 500 }, // 
    { "Firetruck_LA", 1, 501 }, // 
    { "Hustler", 1, 502 }, // 
    { "Intruder", 1, 503 }, // 
    { "Primo", 1, 504 }, // 
    { "Cargobob", 1, 505 }, // 
    { "Tampa", 1, 506 }, // 
    { "Sunrise", 1, 507 }, // 
    { "Merit", 1, 508 }, // 
    { "Utility", 1, 509 }, // 
    { "Nevada", 1, 510 }, // 
    { "Yosemite", 1, 511 }, // 
    { "Windsor", 1, 512 }, // 
    { "Monster_A", 1, 513 }, // 
    { "Monster_B", 1, 514 }, // 
    { "Uranus", 1, 515 }, // 
    { "Jester", 1, 516 }, // 
    { "Sultan", 1, 517 }, // 
    { "Stratum", 1, 518 }, // 
    { "Elegy", 1, 519 }, // 
    { "Raindance", 1, 520 }, // 
    { "RC_Tiger", 1, 521 }, // 
    { "Flash", 1, 522 }, // 
    { "Tahoma", 1, 523 }, // 
    { "Savanna", 1, 524 }, // 
    { "Bandito", 1, 525 }, // 
    { "Freight_Flat", 1, 526 }, // 
    { "Streak_Carriage", 1, 527 }, // 
    { "Kart", 1, 528 }, // 
    { "Mower", 1, 529 }, // 
    { "Duneride", 1, 530 }, // 
    { "Sweeper", 1, 531 }, // 
    { "Broadway", 1, 532 }, // 
    { "Tornado", 1, 533 }, // 
    { "AT-400", 1, 534 }, // 
    { "DFT-30", 1, 535 }, // 
    { "Huntley", 1, 536 }, // 
    { "Stafford", 1, 537 }, // 
    { "BF-400", 1, 538 }, // 
    { "Newsvan", 1, 539 }, // 
    { "Tug", 1, 540 }, // 
    { "Petrol_Trailer", 1, 541 }, // 
    { "Emperor", 1, 542 }, // 
    { "Wayfarer", 1, 543 }, // 
    { "Euros", 1, 544 }, // 
    { "Hotdog", 1, 545 }, // 
    { "Club", 1, 546 }, // 
    { "Freight_Carriage", 1, 547 }, // 
    { "Trailer_3", 1, 548 }, // 
    { "Andromada", 1, 549 }, // 
    { "Dodo", 1, 550 }, // 
    { "RC_Cam", 1, 551 }, // 
    { "Launch", 1, 552 }, // 
    { "Police_Car_(LSPD)", 1, 553 }, // 
    { "Police_Car_(SFPD)", 1, 554 }, // 
    { "Police_Car_(LVPD)", 1, 555 }, // 
    { "Police_Ranger", 1, 556 }, // 
    { "Picador", 1, 557 }, // 
    { "S.W.A.T._Tank", 1, 558 }, // 
    { "Alpha", 1, 559 }, // 
    { "Phoenix", 1, 560 }, // 
    { "Glendale", 1, 561 }, // 
    { "Sadler", 1, 562 }, // 
    { "Luggage_Trailer_A", 1, 563 }, // 
    { "Luggage_Trailer_B", 1, 564 }, // 
    { "Stair_Trailer", 1, 565 }, // 
    { "Boxville", 1, 566 }, // 
    { "Farm_Plow", 1, 567 }, // 
    { "Utility_Trailer", 1, 568 }, // 
    { "Army_Hat", 5, 569 }, // 
    { "Azure_Hat", 5, 570 }, // 
    { "Funky_Hat", 5, 571 }, // 
    { "Dark_Gray_Hat", 5, 572 }, // 
    { "Fire_Hat", 5, 573 }, // 
    { "Dark_Blue_Hat", 5, 574 }, // 
    { "Orange_Hat", 5, 575 }, // 
    { "Light_Gray_Hat", 5, 576 }, // 
    { "Pink_Hat", 5, 577 }, // 
    { "Yellow_Hat", 5, 578 }, // 
    { "Fire_Hat_Boater", 5, 579 }, // 
    { "Gray_Hat_Boater", 5, 580 }, // 
    { "Gray_Hat_Boater_2", 5, 581 }, // 
    { "Black_Hat_Bowler", 5, 582 }, // 
    { "Azure_Hat_Bowler", 5, 583 }, // 
    { "Green_Hat_Bowler", 5, 584 }, // 
    { "Red_Hat_Bowler", 5, 585 }, // 
    { "Light_Green_Hat_Bowler", 5, 586 }, // 
    { "White_Hat_Bowler", 5, 587 }, // 
    { "Simple_Black_Hat", 5, 588 }, // 
    { "Simple_Gray_Hat", 5, 589 }, // 
    { "Simple_Orange_Hat", 5, 590 }, // 
    { "Tiger_Hat", 5, 591 }, // 
    { "Black_&_White_Cool_Hat", 5, 592 }, // 
    { "Black_&_Orange_Cool_Hat", 5, 593 }, // 
    { "Black_&_Green_Cool_Hat", 5, 594 }, // 
    { "Santa_Hat", 5, 595 }, // 
    { "Red_Hoody_Hat", 5, 596 }, // 
    { "Tiger_Hoody_Hat", 5, 597 }, // 
    { "Black_Hoody_Hat", 5, 598 }, // 
    { "White_Dude_Hat", 5, 599 }, // 
    { "Brown_Cowboy_Hat", 5, 600 }, // 
    { "Black_Cowboy_Hat", 5, 601 }, // 
    { "Black_Cowboy_Hat_2", 5, 602 }, // 
    { "Brown_Cowboy_Hat_2", 5, 603 }, // 
    { "Black_Top_Hat", 5, 604 }, // 
    { "White_Top_Hat", 5, 605 }, // 
    { "Black_Skully_Cap", 5, 606 }, // 
    { "Brown_Skully_Cap", 5, 607 }, // 
    { "Funky_Skully_Cap", 5, 608 }, // 
    { "Blue_Beret", 5, 609 }, // 
    { "Red_Beret", 5, 610 }, // 
    { "Dark_Blue_Beret", 5, 611 }, // 
    { "Army_Beret", 5, 612 }, // 
    { "Red_Army_Beret", 5, 613 }, // 
    { "Dark_Blue_CapBack", 5, 614 }, // 
    { "Azure_CapBack", 5, 615 }, // 
    { "Black_CapBack", 5, 616 }, // 
    { "Gray_CapBack", 5, 617 }, // 
    { "Green_CapBack", 5, 618 }, // 
    { "Red_Glasses", 5, 619 }, // 
    { "Green_Glasses", 5, 620 }, // 
    { "Yellow_Glasses", 5, 621 }, // 
    { "Azure_Glasses", 5, 622 }, // 
    { "Pink_Glasses", 5, 623 }, // 
    { "Funky_Glasses", 5, 624 }, // 
    { "Gray_Glasses", 5, 625 }, // 
    { "Funky_Glasses_2", 5, 626 }, // 
    { "Black_&_White_Glasses", 5, 627 }, // 
    { "White_Glasses", 5, 628 }, // 
    { "X-Ray_Glasses", 5, 629 }, // 
    { "Covered_Yellow_Glasses", 5, 630 }, // 
    { "Covered_Orange_Glasses", 5, 631 }, // 
    { "Covered_Red_Glasses", 5, 632 }, // 
    { "Covered_Blue_Glasses", 5, 633 }, // 
    { "Covered_Green_Glasses", 5, 634 }, // 
    { "Cool_Black_Glasses", 5, 635 }, // 
    { "Cool_Azure_Glasses", 5, 636 }, // 
    { "Cool_Blue_Glasses", 5, 637 }, // 
    { "Cool_Pink_Glasses", 5, 638 }, // 
    { "Cool_Red_Glasses", 5, 639 }, // 
    { "Cool_Orange_Glasses", 5, 640 }, // 
    { "Cool_Yellow_Glasses", 5, 641 }, // 
    { "Cool_Yellow_Glasses", 5, 642 }, // 
    { "Pink_Nerd_Glasses", 5, 643 }, // 
    { "Green_Nerd_Glasses", 5, 644 }, // 
    { "Red_Nerd_Glasses", 5, 645 }, // 
    { "Black_Nerd_Glasses", 5, 646 }, // 
    { "Black_&_White_Nerd_Glasses", 5, 647 }, // 
    { "Ocean_Nerd_Glasses", 5, 648 }, // 
    { "Purple_Bandana", 5, 649 }, // 
    { "Red_Bandana", 5, 650 }, // 
    { "Red&White_Bandana", 5, 651 }, // 
    { "Orange_Bandana", 5, 652 }, // 
    { "Skull_Bandana", 5, 653 }, // 
    { "Black_Bandana", 5, 654 }, // 
    { "Blue_Bandana", 5, 655 }, // 
    { "Green_Bandana", 5, 656 }, // 
    { "Pink_Bandana", 5, 657 }, // 
    { "Funky_Bandana", 5, 658 }, // 
    { "Tiger_Bandana", 5, 659 }, // 
    { "Yellow_Bandana", 5, 660 }, // 
    { "Azure_Bandana", 5, 661 }, // 
    { "Dark_Blue_Bandana", 5, 662 }, // 
    { "Olive_Bandana", 5, 663 }, // 
    { "Orange&Yellow_Bandana", 5, 664 }, // 
    { "Funky_Bandana_2", 5, 665 }, // 
    { "Blue_Bandana_2", 5, 666 }, // 
    { "Azure_Bandana_2", 5, 667 }, // 
    { "Fire_Bandana", 5, 668 }, // 
    { "Skull_Bandana_Mask", 5, 669 }, // 
    { "Black_Bandana_Mask", 5, 670 }, // 
    { "Green_Bandana_Mask", 5, 671 }, // 
    { "Army_Bandana_Mask", 5, 672 }, // 
    { "Funky_Bandana_Mask", 5, 673 }, // 
    { "Light_Bandana_Mask", 5, 674 }, // 
    { "Dark_Blue_Bandana_Mask", 5, 675 }, // 
    { "Gray_Bandana_Mask", 5, 676 }, // 
    { "White_Bandana_Mask", 5, 677 }, // 
    { "Colorful_Bandana_Mask", 5, 678 }, // 
    { "White_Headphones", 5, 679 }, // 
    { "Black_Headphones", 5, 680 }, // 
    { "Gray_Headphones", 5, 681 }, // 
    { "Blue_Headphones", 5, 682 }, // 
    { "White_Hockey_Mask", 5, 683 }, // 
    { "Red_Hockey_Mask", 5, 684 }, // 
    { "Green_Hockey_Mask", 5, 685 }, // 
    { "Gas_Mask", 5, 686 }, // 
    { "Sports_Bag", 5, 687 }, // 
    { "Jansport_Backpack", 5, 688 }, // 
    { "Red&White_Motorcycle_Helmet", 5, 689 }, // 
    { "Blue_Motorcycle_Helmet", 5, 690 }, // 
    { "Red_Motorcycle_Helmet", 5, 691 }, // 
    { "White_Motorcycle_Helmet", 5, 692 }, // 
    { "Purple_Motorcycle_Helmet", 5, 693 }, // 
    { "Bass_Guitar", 5, 694 }, // 
    { "Flying_Guitar", 5, 695 }, // 
    { "Warlock_Guitar", 5, 696 }, // 
    { "Fuel", 3000, 697 } // 
};

// add database column
hook OnGameModeInit() {
    for (new i; i < MAXTRAILERITEMS; i++) TrailerStorage:AddResource(TrailerStorage:Data[i][TrailerStorage:Name]);
    return 1;
}

/*
    ### Add resource name into database with default value
*/
stock TrailerStorage:AddResource(const resource[], def = 0) {
    Database:AddColumn(STATIC_VEHICLE_TABLE, resource, "int", sprintf("%d", def));
    return 1;
}

/*
    ### Update static trailer data into database 
*/
stock StaticVehicle:UpdateTrailerDB(staticid) {
    new count = 0;
    new string[4000];
    for (new itemId; itemId < MAXTRAILERITEMS; itemId++) {
        if (count == 0) strcat(string, sprintf(
            "update staticVehicles set `%s` = %d", TrailerStorage:Data[itemId][TrailerStorage:Name], StaticVehicle:Data[staticid][StaticVehicle:Storage][itemId]
        ));
        else strcat(string, sprintf(", `%s` = %d", TrailerStorage:Data[itemId][TrailerStorage:Name], StaticVehicle:Data[staticid][StaticVehicle:Storage][itemId]));
        if (count == 50 || itemId == (MAXTRAILERITEMS - 1)) {
            strcat(string, sprintf(" where id = %d", staticid));
            mysql_tquery(Database, string);
            format(string, sizeof string, "");
            count = 0;
        } else {
            count++;
        }
    }
    return 1;
}

// trucking functions

/*
    ### Get trailerItemID from resource name
*/
stock TrailerStorage:GetID(const resource[]) {
    for (new i; i < MAXTRAILERITEMS; i++) {
        if (IsStringSame(resource, TrailerStorage:Data[i][TrailerStorage:Name])) return i;
    }
    return -1;
}

/*
    ### Get trailerItemID name
*/
stock TrailerStorage:GetName(trailerItemId) {
    new string[50];
    format(string, sizeof string, "unknown");
    format(string, sizeof string, "%s", DynamicShopBusinessItem:GetItemName(TrailerStorage:GetShopItemId(trailerItemId)));
    return string;
}

/*
    ### Get trailerItemID unit
*/
stock TrailerStorage:GetUnit(trailerItemId) {
    new string[50];
    format(string, sizeof string, "unknown");
    format(string, sizeof string, "%s", DynamicShopBusinessItem:GetItemUnit(TrailerStorage:GetShopItemId(trailerItemId)));
    return string;
}

/*
    ### Is trailerItemID valid
*/
stock TrailerStorage:IsValidId(trailerItemId) {
    return (trailerItemId >= 0 && trailerItemId < MAXTRAILERITEMS);
}

/*
    ### Get shop item id from trailerItemId
*/
stock TrailerStorage:GetShopItemId(trailerItemId) {
    return TrailerStorage:Data[trailerItemId][TrailerStorage:itemId];
}

/*
    ### Get shop item id from resource name
*/
stock TrailerStorage:GetShopItemNumber(trailerItemId) {
    return TrailerStorage:Data[trailerItemId][TrailerStorage:itemId];
}

/*
    ### Get trailerItemID from shop id
*/
stock TrailerStorage:GetIdFromShopItemID(shopItemId) {
    for (new i; i < MAXTRAILERITEMS; i++) {
        if (shopItemId == TrailerStorage:Data[i][TrailerStorage:itemId]) return i;
    }
    return -1;
}

/*
    ### Get resource max limit from trailer item id
*/
stock TrailerStorage:GetResourceLimit(trailerItemId) {
    return TrailerStorage:Data[trailerItemId][TrailerStorage:limit];
}

/*
    ### Get resource max limit from name
*/
stock TrailerStorage:GetResourceLimitByName(const resource[]) {
    return TrailerStorage:GetResourceLimit(TrailerStorage:GetID(resource));
}

/*
    ### Get resource amount in trailer using trailer item id
*/
stock TrailerStorage:GetResource(vehicleid, trailerItemId) {
    new staticid = StaticVehicle:GetID(vehicleid);
    if (!StaticVehicle:IsValidID(staticid) || !IsVehicleAllowedForStorage(vehicleid) || !TrailerStorage:IsValidId(trailerItemId)) return 0;
    return StaticVehicle:Data[staticid][StaticVehicle:Storage][trailerItemId];
}

/*
    ### Get resource amount in trailer using resource name
*/
stock TrailerStorage:GetResourceByName(vehicleid, const resource[]) {
    return TrailerStorage:GetResource(vehicleid, TrailerStorage:GetID(resource));
}

/*
    ### Get resource amount in trailer using resource name
*/
stock TrailerStorage:GetResourceByShopId(vehicleid, shopItemId) {
    new staticid = StaticVehicle:GetID(vehicleid);
    new itemId = TrailerStorage:GetIdFromShopItemID(shopItemId);
    if (!StaticVehicle:IsValidID(staticid) || !IsVehicleAllowedForStorage(vehicleid) || itemId == -1) return 0;
    return StaticVehicle:Data[staticid][StaticVehicle:Storage][itemId];
}

/*
    ### get total types of resource loaded in trailer
*/
stock TrailerStorage:GetResourceTypesLoaded(vehicleid) {
    new staticid = StaticVehicle:GetID(vehicleid);
    if (!StaticVehicle:IsValidID(staticid) || !IsVehicleAllowedForStorage(vehicleid)) return 0;
    new type = 0;
    for (new itemId; itemId < MAXTRAILERITEMS; itemId++) {
        if (StaticVehicle:Data[staticid][StaticVehicle:Storage][itemId] > 0) type++;
    }
    return type;
}

/*
    ### set trailer resource value using resource name
*/
stock TrailerStorage:SetResource(vehicleid, trailerItemId, amount = 0) {
    new staticid = StaticVehicle:GetID(vehicleid);
    if (!StaticVehicle:IsValidID(staticid) || !IsVehicleAllowedForStorage(vehicleid) || !TrailerStorage:IsValidId(trailerItemId)) return 0;
    return StaticVehicle:Data[staticid][StaticVehicle:Storage][trailerItemId] = amount;
}

/*
    ### set trailer resource value using resource name
*/
stock TrailerStorage:SetResourceByName(vehicleid, const resource[], amount = 0) {
    return TrailerStorage:SetResource(vehicleid, TrailerStorage:GetID(resource), amount);
}


/*
    ### set trailer resource value using shopid
*/
stock TrailerStorage:SetResourceByShopId(vehicleid, shopItemId, amount = 0) {
    new staticid = StaticVehicle:GetID(vehicleid);
    new itemId = TrailerStorage:GetIdFromShopItemID(shopItemId);
    if (!StaticVehicle:IsValidID(staticid) || !IsVehicleAllowedForStorage(vehicleid) || itemId == -1) return 0;
    return StaticVehicle:Data[staticid][StaticVehicle:Storage][itemId] = amount;
}

/*
    ### increase resource amount in trailer using trailer item id
*/
stock TrailerStorage:IncreaseResource(vehicleid, trailerItemId, amount = 0) {
    new staticid = StaticVehicle:GetID(vehicleid);
    if (!StaticVehicle:IsValidID(staticid) || !IsVehicleAllowedForStorage(vehicleid) || !TrailerStorage:IsValidId(trailerItemId)) return 0;
    return StaticVehicle:Data[staticid][StaticVehicle:Storage][trailerItemId] += amount;
}

/*
    ### increase resource amount in trailer using resource name
*/
stock TrailerStorage:IncreaseResourceByName(vehicleid, const resource[], amount = 0) {
    return TrailerStorage:IncreaseResource(vehicleid, TrailerStorage:GetID(resource), amount);
}

hook OnTrailerCheckInit(playerid, vehicleid) {
    new staticid = StaticVehicle:GetID(vehicleid);
    if (!StaticVehicle:IsValidID(staticid) || !IsVehicleAllowedForStorage(vehicleid)) return 0;
    for (new i; i < MAXTRAILERITEMS; i++) {
        new inTrailer = StaticVehicle:Data[staticid][StaticVehicle:Storage][i];
        if (inTrailer > 0) {
            AlexaMsg(playerid, sprintf("your truck has %d quantity of %s", inTrailer, TrailerStorage:Data[i][TrailerStorage:Name]));
        }
    }
    StaticVehicle:UpdateTrailerDB(staticid);
    return 1;
}

hook OnAlexaResponse(playerid, const cmd[], const text[]) {
    new vehicleid = GetPlayerVehicleID(playerid);
    new trailerid = GetVehicleTrailer(vehicleid);
    if (trailerid != 0) vehicleid = trailerid;
    if (!IsVehicleAllowedForStorage(vehicleid)) {
        return 1;
    }

    if (
        IsStringContainWords(text, "refill trailer") &&
        StaticVehicle:IsValidID(StaticVehicle:GetID(vehicleid)) &&
        GetPlayerAdminLevel(playerid) >= 10
    ) {
        for (new trailerItemId; trailerItemId < MAXTRAILERITEMS; trailerItemId++) {
            TrailerStorage:SetResource(vehicleid, trailerItemId, TrailerStorage:GetResourceLimit(trailerItemId));
        }
        AlexaMsg(playerid, "trailer refilled");
        return ~1;
    }

    if (
        IsStringContainWords(text, "reset trailer") &&
        StaticVehicle:IsValidID(StaticVehicle:GetID(vehicleid)) &&
        GetPlayerAdminLevel(playerid) >= 8
    ) {
        for (new trailerItemId; trailerItemId < MAXTRAILERITEMS; trailerItemId++) {
            TrailerStorage:SetResource(vehicleid, trailerItemId, 0);
        }
        AlexaMsg(playerid, "trailer reseted");
        return ~1;
    }
    return 1;
}