#define VEHICLE_MODEL_TYPE_Car 0
#define VEHICLE_MODEL_TYPE_RC 1
#define VEHICLE_MODEL_TYPE_Truck 2
#define VEHICLE_MODEL_TYPE_Trailer 3
#define VEHICLE_MODEL_TYPE_Cycle 4
#define VEHICLE_MODEL_TYPE_Bike 5
#define VEHICLE_MODEL_TYPE_Heli 6
#define VEHICLE_MODEL_TYPE_Plane 7
#define VEHICLE_MODEL_TYPE_Boat 8

new LightMotor_Vehicles[] = { 400, 401, 402, 404, 405, 409, 410, 411, 412, 413, 415, 416, 418, 419, 420, 421, 422, 423, 424, 426, 429, 434, 436, 438, 439, 440, 442, 445, 451, 457, 458, 459, 466, 467, 470, 471, 474, 475, 477, 478, 479, 480, 482, 483, 485, 489, 490, 492, 494, 495, 496, 500, 502, 503, 504, 505, 506, 507, 516, 517, 518, 525, 526, 527, 528, 529, 530, 531, 532, 533, 534, 535, 536, 540, 541, 542, 543, 545, 546, 547, 549, 550, 551, 552, 554, 555, 558, 559, 560, 561, 562, 565, 566, 567, 568, 571, 572, 574, 575, 576, 579, 580, 582, 583, 585, 587, 589, 596, 597, 598, 599, 600, 602, 603, 604, 605, 609 };
new LightMotor_Vehicles_RC[] = { 441, 464, 465, 564, 594, 606, 607, 608, 610, 611 };
new HeavyMotor_Vehicles[] = { 403, 406, 407, 408, 414, 427, 428, 431, 432, 433, 437, 443, 444, 455, 456, 486, 498, 499, 508, 514, 515, 524, 544, 556, 557, 573, 578, 588, 601 };
new HeavyMotor_Vehicles_2[] = { 435, 449, 450, 501, 537, 538, 569, 570, 584, 590, 591 };
new Cycle_Vehicles[] = { 481, 509, 510 };
new TwoWheelerMotor_Vehicles[] = { 448, 461, 462, 463, 468, 521, 522, 523, 581, 586 };
new HelicopterMotor_Vehicles[] = { 417, 425, 447, 469, 487, 488, 497, 548, 563 };
new PlaneMotor_Vehicles[] = { 460, 476, 511, 512, 513, 519, 520, 553, 577, 592, 593 };
new BoatMotor_Vehicles[] = { 430, 446, 452, 453, 454, 472, 473, 484, 493, 539, 595 };

stock IsVehicleModelCar(vehicleid) { return IsModelCar(GetVehicleModel(vehicleid)); }
stock IsVehicleModelRC(vehicleid) { return IsModelRC(GetVehicleModel(vehicleid)); }
stock IsVehicleModelTruck(vehicleid) { return IsModelTruck(GetVehicleModel(vehicleid)); }
stock IsVehicleModelTrailer(vehicleid) { return IsModelTrailer(GetVehicleModel(vehicleid)); }
stock IsVehicleModelCycle(vehicleid) { return IsModelCycle(GetVehicleModel(vehicleid)); }
stock IsVehicleModelBike(vehicleid) { return IsModelBike(GetVehicleModel(vehicleid)); }
stock IsVehicleModelHeli(vehicleid) { return IsModelHeli(GetVehicleModel(vehicleid)); }
stock IsVehicleModelPlane(vehicleid) { return IsModelPlane(GetVehicleModel(vehicleid)); }
stock IsVehicleModelBoat(vehicleid) { return IsModelBoat(GetVehicleModel(vehicleid)); }

stock IsVehicleModelByType(modelid, typeid) {
    if (typeid < 0 || typeid > 8) return 0;
    if (IsModelCar(modelid) && typeid == VEHICLE_MODEL_TYPE_Car) return 1;
    if (IsModelRC(modelid) && typeid == VEHICLE_MODEL_TYPE_RC) return 1;
    if (IsModelTruck(modelid) && typeid == VEHICLE_MODEL_TYPE_Truck) return 1;
    if (IsModelTrailer(modelid) && typeid == VEHICLE_MODEL_TYPE_Trailer) return 1;
    if (IsModelCycle(modelid) && typeid == VEHICLE_MODEL_TYPE_Cycle) return 1;
    if (IsModelBike(modelid) && typeid == VEHICLE_MODEL_TYPE_Bike) return 1;
    if (IsModelHeli(modelid) && typeid == VEHICLE_MODEL_TYPE_Heli) return 1;
    if (IsModelPlane(modelid) && typeid == VEHICLE_MODEL_TYPE_Plane) return 1;
    if (IsModelBoat(modelid) && typeid == VEHICLE_MODEL_TYPE_Boat) return 1;
    return 0;
}

stock IsModelCar(modelid) { return IsArrayContainNumber(LightMotor_Vehicles, modelid); }
stock IsModelRC(modelid) { return IsArrayContainNumber(LightMotor_Vehicles_RC, modelid); }
stock IsModelTruck(modelid) { return IsArrayContainNumber(HeavyMotor_Vehicles, modelid); }
stock IsModelTrailer(modelid) { return IsArrayContainNumber(HeavyMotor_Vehicles_2, modelid); }
stock IsModelCycle(modelid) { return IsArrayContainNumber(Cycle_Vehicles, modelid); }
stock IsModelBike(modelid) { return IsArrayContainNumber(TwoWheelerMotor_Vehicles, modelid); }
stock IsModelHeli(modelid) { return IsArrayContainNumber(HelicopterMotor_Vehicles, modelid); }
stock IsModelPlane(modelid) { return IsArrayContainNumber(PlaneMotor_Vehicles, modelid); }
stock IsModelBoat(modelid) { return IsArrayContainNumber(BoatMotor_Vehicles, modelid); }

#define VEH_MOD_SIDE_LEFT 0
#define VEH_MOD_SIDE_RIGHT 1

new resvlistHoods[] = { 401, 426, 492, 518, 546, 549, 550, 589 };
new resvlistVents[] = { 401, 518, 546, 517, 603, 547, 439, 550, 549 };
new resvlistLights[] = { 400, 401, 436, 439, 518, 589, 603 };
new resvlistExhausts[] = { 400, 401, 405, 415, 426, 436, 517, 518, 527, 534, 535, 536, 542, 547, 549, 550, 558, 559, 560, 561, 562, 565, 567, 575, 576, 477, 580, 589, 603, 542, 546, 400, 517, 603 };
new resvlistFrontBumpers[] = { 534, 535, 536, 558, 559, 560, 561, 562, 565, 567, 575, 576 };
new resvlistRearBumpers[] = { 534, 535, 536, 558, 559, 560, 561, 562, 565, 567, 575, 576 };
new resvlistRoofs[] = { 401, 426, 436, 477, 492, 518, 536, 546, 550, 558, 559, 560, 561, 562, 565, 567, 580, 589, 603 };
new resvlistSpoilers[] = { 401, 405, 415, 426, 436, 542, 477, 492, 517, 518, 527, 546, 547, 549, 550, 558, 559, 560, 561, 562, 565, 580, 589, 603 };
new resvlistSideSkirts[] = { 401, 415, 436, 439, 477, 517, 518, 527, 534, 535, 536, 546, 549, 558, 559, 560, 561, 562, 565, 567, 575, 576, 580, 589, 603 };
new resvlistBullbars[] = { 534, 535 };
new allowedPaintJobs[] = { 415, 534, 535, 536, 558, 559, 560, 561, 562, 565, 567, 575 };

stock ModShop:IsModelSupportWheels(modelid) {
    if (IsArrayContainNumber(LightMotor_Vehicles, modelid) || IsArrayContainNumber(HeavyMotor_Vehicles, modelid)) return 1;
    return 0;
}

stock ModShop:IsModelSupportNeonLight(modelid) {
    if (IsArrayContainNumber(LightMotor_Vehicles, modelid) || IsArrayContainNumber(HeavyMotor_Vehicles, modelid)) return 1;
    return 0;
}

stock ModShop:IsModelSupportNitrousOxide(modelid) {
    if (IsArrayContainNumber(LightMotor_Vehicles, modelid) || IsArrayContainNumber(HeavyMotor_Vehicles, modelid)) return 1;
    return 0;
}

stock ModShop:IsModelSupportHydraulics(modelid) {
    if (IsArrayContainNumber(LightMotor_Vehicles, modelid) || IsArrayContainNumber(HeavyMotor_Vehicles, modelid)) return 1;
    return 0;
}

stock ModShop:IsModelSupportCarStereo(modelid) {
    if (IsArrayContainNumber(LightMotor_Vehicles, modelid) || IsArrayContainNumber(HeavyMotor_Vehicles, modelid)) return 1;
    return 0;
}

stock ModShop:IsModelSupportHoods(modelid) {
    return IsArrayContainNumber(resvlistHoods, modelid);
}

stock ModShop:IsModelSupportVents(modelid) {
    return IsArrayContainNumber(resvlistVents, modelid);
}

stock ModShop:IsModelSupportLights(modelid) {
    return IsArrayContainNumber(resvlistLights, modelid);
}

stock ModShop:IsModelSupportExhausts(modelid) {
    return IsArrayContainNumber(resvlistExhausts, modelid);
}

stock ModShop:IsModelSupportFrontBumpers(modelid) {
    return IsArrayContainNumber(resvlistFrontBumpers, modelid);
}

stock ModShop:IsModelSupportRearBumpers(modelid) {
    return IsArrayContainNumber(resvlistRearBumpers, modelid);
}

stock ModShop:IsModelSupportRoofs(modelid) {
    return IsArrayContainNumber(resvlistRoofs, modelid);
}

stock ModShop:IsModelSupportSpoilers(modelid) {
    return IsArrayContainNumber(resvlistSpoilers, modelid);
}

stock ModShop:IsModelSupportSideSkirts(modelid) {
    return IsArrayContainNumber(resvlistSideSkirts, modelid);
}

stock ModShop:IsModelSupportBullbars(modelid) {
    return IsArrayContainNumber(resvlistBullbars, modelid);
}

stock ModShop:IsModelSupportPaintJobs(modelid) {
    return IsArrayContainNumber(allowedPaintJobs, modelid);
}

#define VEH_HOOD_TYPE_Fury 0
#define VEH_HOOD_TYPE_Champ 1
#define VEH_HOOD_TYPE_Race 2
#define VEH_HOOD_TYPE_Worx 3

stock ModShop:GetModelCompIDHood(modelid, type) {
    new VehicleElig[][10] = {
        { 401, 518, 589, 492, 426, 550 },
        { 401, 426, 492, 546, 550 },
        { 549 },
        { 549 }
    };
    new Component[] = { 1005, 1004, 1011, 1012 };
    if (type < 0 || type > 3 || !IsArrayContainNumber(VehicleElig[type], modelid)) return -1;
    return Component[type];
}

#define VEH_VENT_TYPE_Oval 0
#define VEH_VENT_TYPE_Square 1

stock ModShop:GetModelCompIDVent(modelid, type, VEH_MOD_SIDE = VEH_MOD_SIDE_LEFT | VEH_MOD_SIDE_RIGHT) {
    new VehicleElig[][10] = {
        { 401, 518, 546, 517, 603, 547, 439, 550, 549 },
        { 401, 518, 546, 517, 603, 439, 550, 549 }
    };
    new Component[][] = {
        { 1142, 1143 },
        { 1144, 1145 }
    };
    if (type < 0 || type > 1 || !IsArrayContainNumber(VehicleElig[type], modelid)) return -1;
    return Component[type][VEH_MOD_SIDE];
}

#define VEH_LIGHT_TYPE_Round 0
#define VEH_LIGHT_TYPE_Square 1

stock ModShop:GetModelCompIDLight(modelid, type) {
    new VehicleElig[][10] = {
        { 400, 401, 436, 439, 518, 589 },
        { 589, 603, 400 }
    };
    new Component[] = { 1013, 1024 };
    if (type < 0 || type > 1 || !IsArrayContainNumber(VehicleElig[type], modelid)) return -1;
    return Component[type];
}

// Wheel Arc. Alien exhaust
#define VEH_EXHAUST_TYPE_0 0
// Wheel Arc. X-Flow exhaust
#define VEH_EXHAUST_TYPE_1 1
// Low Co. Chromer exhaust
#define VEH_EXHAUST_TYPE_2 2
// Low Co. Slamin exhaust
#define VEH_EXHAUST_TYPE_3 3
// Transfender Large exhaust
#define VEH_EXHAUST_TYPE_4 4
// Transfender Medium exhaust
#define VEH_EXHAUST_TYPE_5 5
// Transfender Small exhaust
#define VEH_EXHAUST_TYPE_6 6
// Transfender Twin exhaust
#define VEH_EXHAUST_TYPE_7 7
// Transfender Upswept exhaust
#define VEH_EXHAUST_TYPE_8 8

stock ModShop:GetModelCompIDExhausts(modelid, type) {
    new VehicleElig[][20] = {
        { 558, 559, 560, 561, 562, 565 },
        { 558, 559, 560, 561, 562, 565 },
        { 534, 535, 536, 567, 575, 576 },
        { 534, 535, 536, 567, 575, 576 },
        { 400, 401, 405, 426, 477, 517, 518, 527, 542, 547, 549, 550, 580, 589, 603 },
        { 400, 405, 426, 436, 477, 527, 542, 547 },
        { 436 },
        { 400, 405, 415, 426, 436, 477, 517, 518, 542, 546, 547, 549, 550, 603 },
        { 400, 401, 405, 415, 518, 426, 477, 517, 542, 546, 547, 549, 550, 603 }
    };
    new Component[][20] = {
        { 1089, 1065, 1028, 1064, 1034, 1046 },
        { 1092, 1066, 1029, 1059, 1037, 1045 },
        { 1126, 1113, 1104, 1129, 1044, 1136 },
        { 1127, 1114, 1105, 1132, 1043, 1135 },
        { 1020, 1020, 1020, 1020, 1020, 1020, 1020, 1020, 1020, 1020, 1020, 1020, 1020, 1020, 1020, 1020 },
        { 1021, 1021, 1021, 1021, 1021, 1021, 1021, 1021 },
        { 1022 },
        { 1019, 1019, 1019, 1019, 1019, 1019, 1019, 1019, 1019, 1019, 1019, 1019, 1019, 1019, 1019 },
        { 1018, 1018, 1018, 1018, 1018, 1018, 1018, 1018, 1018, 1018, 1018, 1018, 1018, 1018, 1018 }
    };
    if (type < 0 || type > 8 || !IsArrayContainNumber(VehicleElig[type], modelid)) return -1;
    new index = GetArrayIndex(VehicleElig[type], modelid);
    return Component[type][index];
}

// Wheel Arc. Alien Bumper
#define VEH_BUMPER_TYPE_0 0
// Wheel Arc. X-Flow Bumper
#define VEH_BUMPER_TYPE_1 1
// Low co. Chromer Bumper
#define VEH_BUMPER_TYPE_2 2
// Low co. Slamin Bumper
#define VEH_BUMPER_TYPE_3 3

stock ModShop:GetModelCompIDFrontBumper(modelid, type) {
    new VehicleElig[][20] = {
        { 558, 559, 560, 561, 562, 565 },
        { 558, 559, 560, 561, 562, 565 },
        { 534, 535, 536, 567, 575, 576 },
        { 534, 535, 536, 567, 575, 576 }
    };
    new Component[][20] = {
        { 1166, 1160, 1169, 1155, 1171, 1153 },
        { 1165, 1173, 1170, 1157, 1172, 1152 },
        { 1179, 1115, 1182, 1189, 1174, 1191 },
        { 1185, 1116, 1181, 1188, 1175, 1190 }
    };
    if (type < 0 || type > 3 || !IsArrayContainNumber(VehicleElig[type], modelid)) return -1;
    new index = GetArrayIndex(VehicleElig[type], modelid);
    return Component[type][index];
}

stock ModShop:GetModelCompIDRearBumper(modelid, type) {
    new VehicleElig[][20] = {
        { 558, 559, 560, 561, 562, 565 },
        { 558, 559, 560, 561, 562, 565 },
        { 534, 535, 536, 567, 575, 576 },
        { 534, 535, 536, 567, 575, 576 }
    };
    new Component[][20] = {
        { 1168, 1159, 1141, 1154, 1149, 1150 },
        { 1167, 1161, 1140, 1156, 1148, 1151 },
        { 1180, 1109, 1184, 1187, 1176, 1192 },
        { 1178, 1110, 1183, 1186, 1177, 1193 }
    };
    if (type < 0 || type > 3 || !IsArrayContainNumber(VehicleElig[type], modelid)) return -1;
    new index = GetArrayIndex(VehicleElig[type], modelid);
    return Component[type][index];
}

// Wheel Arc. Alien
#define VEH_ROOF_TYPE_0 0
// Wheel Arc. X-Flow
#define VEH_ROOF_TYPE_1 1
// Low Co. Hardtop Roof
#define VEH_ROOF_TYPE_2 2
// Low Co. Softtop Roof
#define VEH_ROOF_TYPE_3 3
// Transfender Roof Scoop
#define VEH_ROOF_TYPE_4 4

stock ModShop:GetModelCompIDRoof(modelid, type) {
    new VehicleElig[][20] = {
        { 558, 559, 560, 561, 562, 565 },
        { 558, 559, 560, 561, 562, 565 },
        { 536, 567 },
        { 536, 567 },
        { 401, 426, 436, 477, 492, 518, 546, 550, 580, 589, 603 }
    };
    new Component[][20] = {
        { 1088, 1067, 1032, 1055, 1038, 1054 },
        { 1091, 1068, 1033, 1061, 1035, 1053 },
        { 1128, 1130 },
        { 1103, 1131 },
        { 1006, 1006, 1006, 1006, 1006, 1006, 1006, 1006, 1006, 1006, 1006 }
    };
    if (type < 0 || type > 4 || !IsArrayContainNumber(VehicleElig[type], modelid)) return -1;
    new index = GetArrayIndex(VehicleElig[type], modelid);
    return Component[type][index];
}

// Wheel Arc. Alien Spoiler
#define VEH_SPOILER_TYPE_0 0
// Wheel Arc. X-Flow Spoiler
#define VEH_SPOILER_TYPE_1 1
// Transfender Win Spoiler
#define VEH_SPOILER_TYPE_2 2
// Transfender Fury Spoiler
#define VEH_SPOILER_TYPE_3 3
// Transfender Alpha Spoiler
#define VEH_SPOILER_TYPE_4 4
// Transfender Pro Spoiler
#define VEH_SPOILER_TYPE_5 5
// Transfender Champ Spoiler
#define VEH_SPOILER_TYPE_6 6
// Transfender Race Spoiler
#define VEH_SPOILER_TYPE_7 7
// Transfender Drag Spoiler
#define VEH_SPOILER_TYPE_8 8

stock ModShop:GetModelCompIDSpoiler(modelid, type) {
    new VehicleElig[][20] = {
        { 558, 559, 560, 561, 562, 565 },
        { 558, 559, 560, 561, 562, 565 },
        { 401, 405, 415, 477, 518, 426, 527, 436, 546, 549, 550, 580, 603 },
        { 405, 415, 477, 517, 518, 546, 549, 550, 580, 603 },
        { 401, 415, 426, 436, 477, 517, 518, 547, 549, 550 },
        { 405, 492, 547, 589 },
        { 405, 527, 542 },
        { 527, 542 },
        { 517, 546 }
    };
    new Component[][20] = {
        { 1164, 1162, 1138, 1158, 1147, 1049 },
        { 1163, 1158, 1139, 1060, 1146, 1150 },
        { 1001, 1001, 1001, 1001, 1001, 1001, 1001, 1001, 1001, 1001, 1001, 1001, 1001 },
        { 1023, 1023, 1023, 1023, 1023, 1023, 1023, 1023, 1023, 1023 },
        { 1003, 1003, 1003, 1003, 1003, 1003, 1003, 1003, 1003, 1003 },
        { 1000, 1000, 1000, 1000 },
        { 1014, 1014, 1014 },
        { 1002, 1002 },
        { 1002, 1002 }
    };
    if (type < 0 || type > 8 || !IsArrayContainNumber(VehicleElig[type], modelid)) return -1;
    new index = GetArrayIndex(VehicleElig[type], modelid);
    return Component[type][index];
}

// Wheel Arc. Alien Side Skirt
#define VEH_SIDE_SKIRTS_TYPE_0 0
// Wheel Arc. X-Flow Side Skirt
#define VEH_SIDE_SKIRTS_TYPE_1 1
// Locos Chrome Strip
#define VEH_SIDE_SKIRTS_TYPE_2 2
// Locos Chrome Flames
#define VEH_SIDE_SKIRTS_TYPE_3 3
// Locos Chrome Arches
#define VEH_SIDE_SKIRTS_TYPE_4 4
// Locos Chrome Trim
#define VEH_SIDE_SKIRTS_TYPE_5 5
// Locos Wheelcovers
#define VEH_SIDE_SKIRTS_TYPE_6 6
// Transfender Side Skirt
#define VEH_SIDE_SKIRTS_TYPE_7 7

stock ModShop:GetModelCompIDSideSkirts(modelid, type) {
    new VehicleElig[][20] = {
        { 558, 559, 560, 561, 562, 565 },
        { 558, 559, 560, 561, 562, 565 },
        { 536, 567, 575, 576 },
        { 534 },
        { 534 },
        { 535 },
        { 535 },
        { 401, 415, 436, 439, 477, 517, 518, 527, 546, 549, 580, 589, 603 }
    };
    new Component[][20] = {
        { 1094, 1071, 1027, 1062, 1040, 1051 },
        { 1095, 1072, 1031, 1063, 1041, 1052 },
        { 1108, 1133, 1099, 1137 },
        { 1122 },
        { 1124 },
        { 1120 },
        { 1121 },
        { 1017, 1017, 1017, 1017, 1017, 1017, 1017, 1017, 1017, 1017, 1017, 1017, 1017, 1017 }
    };
    if (type < 0 || type > 7 || !IsArrayContainNumber(VehicleElig[type], modelid)) return -1;
    new index = GetArrayIndex(VehicleElig[type], modelid);
    return Component[type][index];
}

// Locos Chrome Grill
#define VEH_BULLBAR_TYPE_0 0
// Locos Chrome Bars
#define VEH_BULLBAR_TYPE_1 1
// Locos Chrome Lights
#define VEH_BULLBAR_TYPE_2 2
// Locos Chrome Bullbar
#define VEH_BULLBAR_TYPE_3 3

stock ModShop:GetModelCompIDBullBar(modelid, type) {
    new VehicleElig[][20] = {
        { 534 },
        { 534 },
        { 534 },
        { 535 }
    };
    new Component[][20] = {
        { 1100 },
        { 1123 },
        { 1125 },
        { 1117 }
    };
    if (type < 0 || type > 3 || !IsArrayContainNumber(VehicleElig[type], modelid)) return -1;
    new index = GetArrayIndex(VehicleElig[type], modelid);
    return Component[type][index];
}

// Paint Job 0
#define VEH_PAINT_JOB_TYPE_0 0
// Paint Job 1
#define VEH_PAINT_JOB_TYPE_1 1
// Paint Job 2
#define VEH_PAINT_JOB_TYPE_2 2
// Paint Job 3
#define VEH_PAINT_JOB_TYPE_3 3
// Paint Job 4
#define VEH_PAINT_JOB_TYPE_4 4
stock ModShop:GetModelPaintJob(modelid, type) {
    if (type < 0 || type > 4 || !ModShop:IsModelSupportPaintJobs(modelid)) return -1;
    return type;
}

#define VEH_WHEEL_TYPE_Offroad 0
#define VEH_WHEEL_TYPE_Mega 1
#define VEH_WHEEL_TYPE_Wires 2
#define VEH_WHEEL_TYPE_Twist 3
#define VEH_WHEEL_TYPE_Grove 4
#define VEH_WHEEL_TYPE_Import 5
#define VEH_WHEEL_TYPE_Atomic 6
#define VEH_WHEEL_TYPE_Ahab 7
#define VEH_WHEEL_TYPE_Virtual 8
#define VEH_WHEEL_TYPE_Access 9
#define VEH_WHEEL_TYPE_Trance 10
#define VEH_WHEEL_TYPE_Shadow 11
#define VEH_WHEEL_TYPE_Rimshine 12
#define VEH_WHEEL_TYPE_Classic 13
#define VEH_WHEEL_TYPE_Cutter 14
#define VEH_WHEEL_TYPE_Switch 15
#define VEH_WHEEL_TYPE_Dollar 16

stock ModShop:GetModelWheel(type) {
    new components[] = { 1025, 1074, 1076, 1078, 1081, 1082, 1085, 1096, 1097, 1098, 1084, 1073, 1075, 1077, 1079, 1080, 1083 };
    if (type < 0 || type > 16) return -1;
    return components[type];
}

stock ModShop:GetModelCarStereo(modelid) {
    if (modelid < 400 || modelid > 611) return -1;
    return 1086;
}

stock ModShop:GetModelHydraulics(modelid) {
    if (modelid < 400 || modelid > 611) return -1;
    return 1087;
}

stock ModShop:GetModelNitro(modelid, type) {
    if (modelid < 400 || modelid > 611 || type < 0 || type > 2) return -1;
    new components[] = { 1008, 1009, 1010 };
    return components[type];
}