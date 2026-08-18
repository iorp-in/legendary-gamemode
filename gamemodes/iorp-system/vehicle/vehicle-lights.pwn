enum {
    VehicleLights:Turn_Off_All_Lights,
    VehicleLights:Turn_All_Lights,
    VehicleLights:Turn_Left_Lights,
    VehicleLights:Turn_Right_Lights
}
enum VehicleLights:dataenum {
    VehicleLights:status,
    VehicleLights:time,
    VehicleLights:objects[4],
    Float:VehicleLights:vehicleangle
}
new VehicleLights:data[MAX_VEHICLES][VehicleLights:dataenum];
new VehicleLights:playerdata[MAX_PLAYERS];

new Float:VehicleLights:LightsPos[212][6] = {
    { 0.8766, 2.0272, -0.1000, 0.8766, -2.2272, -0.1000 },
    { 0.9566, 2.4500, 0.0000, 0.9566, -2.3500, 0.0000 },
    { 0.8033, 2.5363, 0.0000, 0.9033, -2.6363, 0.0000 },
    { 1.1500, 4.1909, -0.2000, 0.3499, -4.1909, -0.7000 },
    { 0.7333, 2.2409, 0.2000, 0.8333, -2.6409, 0.0000 },
    { 0.9833, 2.2272, -0.1000, 0.8833, -2.7272, -0.1000 },
    { 1.0566, 5.2681, 0.0000, 2.2566, -5.1681, 0.4000 },
    { 0.8499, 4.0727, 0.1000, 1.0499, -3.4727, 0.2000 },
    { 0.9399, 4.8590, -0.4000, 0.8399, -4.0590, -0.5000 },
    { 0.8899, 3.6181, 0.0000, 0.8899, -3.9181, 0.0000 },
    { 0.8533, 2.1772, 0.0000, 0.8533, -2.1772, 0.0000 },
    { 0.9966, 2.6272, -0.2000, 0.8966, -2.4272, 0.0000 },
    { 0.9166, 2.6227, -0.1000, 0.8166, -3.6227, -0.2000 },
    { 0.9600, 2.6727, -0.1000, 0.9600, -2.6727, 0.0000 },
    { 0.7399, 2.8136, -0.1000, 1.0399, -3.2136, 0.0000 },
    { 0.8733, 2.5045, -0.3000, 0.7733, -2.5045, 0.0000 },
    { 0.9099, 2.9409, 0.0000, 1.1100, -3.7409, -0.5000 },
    { 1.8166, 10.5772, 0.0000, 1.8166, -10.5772, 0.0000 },
    { 0.9566, 2.4772, -0.2000, 1.0566, -2.5772, -0.2000 },
    { 0.8000, 2.7272, -0.4000, 0.8000, -2.9272, -0.2000 },
    { 0.9033, 2.3863, 0.0000, 0.9033, -2.6863, 0.0000 },
    { 0.8500, 2.6045, -0.2000, 0.8500, -2.9045, -0.2000 },
    { 0.7566, 2.2454, -0.3000, 0.8566, -2.4454, -0.3000 },
    { 0.7733, 2.2999, 0.0000, 0.8733, -2.2000, 0.0000 },
    { 0.7199, 1.5545, 0.2000, 0.6199, -1.6545, 0.3000 },
    { 1.7199, 8.4681, 0.0000, 1.7199, -8.4681, 0.0000 },
    { 1.0033, 2.3863, 0.0000, 0.9033, -2.6863, 0.0000 },
    { 0.8800, 3.3272, -0.1000, 0.9800, -3.7272, 0.3000 },
    { 0.9100, 2.5545, 0.2000, 0.9100, -2.9545, 0.2000 },
    { 0.7366, 2.2545, -0.3000, 0.8366, -2.4545, 0.0000 },
    { 1.5900, 7.6818, 0.0000, 1.5900, -7.6818, 0.0000 },
    { 1.0033, 5.9499, 0.4000, 1.0033, -5.8499, 0.0000 },
    { 1.4333, 4.1681, 0.0000, 1.4333, -4.1681, 0.0000 },
    { 1.2333, 3.7454, -0.1000, 1.3333, -4.7454, -0.1000 },
    { 0.5633, 1.9772, -0.1000, 0.4633, -1.9772, -0.1000 },
    { 1.0533, 6.1499, 0.0000, 1.0533, -3.9500, -1.1000 },
    { 0.8600, 2.3045, 0.0000, 0.8600, -2.5045, 0.0000 },
    { 1.2133, 5.5454, -0.2000, 1.1133, -5.2454, 0.4000 },
    { 0.9033, 2.6454, 0.0000, 0.9033, -2.7454, -0.1000 },
    { 0.8400, 2.4045, -0.5000, 0.8400, -2.7045, -0.1000 },
    { 0.9700, 2.6272, -0.3000, 0.8700, -2.6272, 0.1000 },
    { 0.2899, 0.6409, 0.0000, 0.2899, -0.6409, 0.0000 },
    { 0.9699, 2.8363, -0.2000, 1.0699, -3.0363, 0.0000 },
    { 1.0866, 5.8136, -1.0000, 1.2866, -7.1136, -0.9000 },
    { 1.1200, 2.7363, 0.7000, 1.1200, -3.0363, 0.7000 },
    { 0.9666, 2.3636, 0.0000, 0.9666, -2.7636, -0.2000 },
    { 1.5900, 7.7363, 0.0000, 1.5900, -7.7363, 0.0000 },
    { 0.8066, 6.7272, 0.0000, 0.8066, -6.7272, 0.0000 },
    { 0.2366, 0.9954, 0.0000, 0.2366, -0.9954, 0.0000 },
    { 1.0099, 4.1045, 0.0000, 1.0099, -4.1045, 0.0000 },
    { 1.0233, 6.1409, 0.0000, 1.0233, -3.9409, -1.2000 },
    { 0.7733, 2.0863, -0.2000, 0.8733, -2.4863, -0.2000 },
    { 1.2033, 6.6227, 0.0000, 1.2033, -6.6227, 0.0000 },
    { 1.7133, 6.2590, 0.0000, 1.7133, -6.2590, 0.0000 },
    { 2.2066, 8.6590, 0.0000, 2.2066, -8.6590, 0.0000 },
    { 1.2066, 3.7090, -0.1000, 1.3066, -4.7090, -0.1000 },
    { 0.8766, 3.3272, -0.1000, 0.8766, -4.6272, -0.5000 },
    { 0.4099, 1.1863, 0.0000, 0.5099, -1.2863, 0.0000 },
    { 0.9033, 2.4909, -0.2000, 0.9033, -2.7909, 0.0000 },
    { 0.9666, 2.5999, -0.1000, 0.8666, -2.5999, 0.1000 },
    { 3.6166, 6.1590, 0.0000, 3.6166, -6.1590, 0.0000 },
    { 0.2333, 0.8181, 0.5000, 0.2333, -1.1181, 0.3000 },
    { 0.2366, 0.9954, 0.0000, 0.2366, -0.9954, 0.0000 },
    { 0.2333, 1.1000, 0.0000, 0.2333, -1.1000, 0.0000 },
    { 0.5266, 0.5045, 0.0000, 0.5266, -0.7045, 0.0000 },
    { 0.2899, 0.6409, 0.0000, 0.2899, -0.6409, 0.0000 },
    { 0.9433, 2.6045, 0.1000, 1.0433, -2.8045, 0.0000 },
    { 0.6433, 2.8909, -0.1000, 0.9433, -3.0909, 0.0000 },
    { 0.2366, 1.0136, 0.0000, 0.2366, -1.0136, 0.0000 },
    { 0.8066, 6.7272, 0.0000, 0.8066, -6.7272, 0.0000 },
    { 1.0866, 2.0909, 0.2000, 1.0866, -2.6909, -0.2000 },
    { 0.4733, 0.9090, 0.0000, 0.4733, -0.9090, 0.0000 },
    { 0.8900, 4.2454, 0.0000, 0.8900, -4.2454, 0.0000 },
    { 0.9666, 2.4545, 0.0000, 0.9666, -2.4545, 0.0000 },
    { 0.9100, 2.7409, 0.0000, 1.0099, -2.7409, -0.1000 },
    { 0.9166, 2.5272, -0.3000, 0.8166, -2.8272, -0.3000 },
    { 3.6766, 5.1318, 0.0000, 3.6766, -5.1318, 0.0000 },
    { 0.7900, 2.6954, -0.2000, 1.0900, -2.5954, 0.1000 },
    { 0.9166, 2.2318, 0.0000, 1.0166, -2.5318, -0.3000 },
    { 0.9500, 2.4954, 0.0000, 0.9500, -2.7954, 0.0000 },
    { 0.8566, 1.7909, 0.0000, 0.8566, -2.2909, -0.2000 },
    { 0.2366, 0.8545, 0.0000, 0.2366, -0.8545, 0.0000 },
    { 0.8799, 2.3909, -0.4000, 0.8799, -2.5909, 0.0000 },
    { 0.7833, 2.6136, 0.0000, 0.6833, -2.8136, -0.3000 },
    { 1.7833, 11.9090, 0.0000, 1.7833, -11.9090, 0.0000 },
    { 0.6566, 1.7500, 0.0000, 0.6566, -1.3499, 0.0000 },
    { 0.8466, 1.5636, 1.0000, 0.5466, -3.2636, 1.1000 },
    { 0.7766, 6.8363, 0.0000, 0.7766, -6.8363, 0.0000 },
    { 0.7766, 5.7318, 0.0000, 0.7766, -5.7318, 0.0000 },
    { 1.0466, 2.5909, 0.0000, 1.1466, -2.6909, 0.2000 },
    { 0.9733, 3.1499, 0.0000, 1.1733, -3.1499, 0.1000 },
    { 0.8700, 2.5772, -0.1000, 0.8700, -2.8772, 0.0000 },
    { 0.7833, 2.6090, 0.0000, 0.7833, -2.8090, 0.0000 },
    { 1.5900, 8.1045, 0.0000, 1.5900, -8.1045, 0.0000 },
    { 0.8500, 2.3500, -0.2000, 0.8500, -2.8499, 0.1000 },
    { 1.1266, 2.3772, 0.0000, 1.1266, -2.0772, 0.0000 },
    { 0.9600, 2.2590, 0.0000, 0.9600, -2.0590, 0.0000 },
    { 0.7766, 6.8363, 0.0000, 0.7766, -6.8363, 0.0000 },
    { 0.8666, 3.0999, 0.2000, 0.9666, -3.0999, 0.3000 },
    { 0.7799, 2.5727, -0.2000, 1.0800, -3.4727, 0.1000 },
    { 0.4633, 2.0772, -0.2000, 0.7633, -1.9772, 0.0000 },
    { 0.2899, 0.6409, 0.0000, 0.2899, -0.6409, 0.0000 },
    { 0.8833, 2.6136, -0.2000, 0.7833, -2.7136, 0.0000 },
    { 0.8366, 2.3909, 0.0000, 0.8366, -2.8909, 0.0000 },
    { 0.9433, 2.6454, 0.1000, 1.0433, -2.8454, 0.0000 },
    { 1.0466, 2.5909, 0.0000, 1.1466, -2.6909, 0.1000 },
    { 0.7500, 2.2727, -0.3000, 0.8500, -2.3727, 0.0000 },
    { 1.0566, 2.5954, -0.1000, 1.1566, -2.8954, -0.1000 },
    { 0.6866, 2.9590, -0.7000, 0.9866, -3.7590, 0.0000 },
    { 0.2366, 0.8636, 0.0000, 0.2366, -0.8636, 0.0000 },
    { 0.2400, 0.7909, 0.0000, 0.2400, -0.7909, 0.0000 },
    { 7.0733, 9.6318, 0.0000, 7.0733, -9.6318, 0.0000 },
    { 3.7200, 2.7999, 0.0000, 3.7200, -2.7999, 0.0000 },
    { 2.8999, 4.0909, 0.0000, 2.8999, -4.0909, 0.0000 },
    { 1.2633, 4.2772, 0.1000, 0.3633, -5.0772, -0.4000 },
    { 1.2833, 4.4227, -0.5000, 0.3833, -4.6227, -1.3000 },
    { 0.9666, 2.7363, 0.0000, 0.9666, -2.8363, 0.0000 },
    { 0.9433, 2.7772, 0.0000, 0.9433, -2.7772, -0.1000 },
    { 0.8100, 2.7272, 0.0000, 1.0099, -2.8272, -0.2000 },
    { 6.7699, 8.7681, 0.0000, 6.7699, -8.7681, 0.0000 },
    { 2.9166, 6.5090, 0.0000, 2.9166, -6.5090, 0.0000 },
    { 0.2333, 1.1181, 0.0000, 0.2333, -1.1181, 0.0000 },
    { 0.2333, 1.1181, 0.0000, 0.2333, -1.1181, 0.0000 },
    { 0.2333, 1.1227, 0.0000, 0.2333, -1.1227, 0.0000 },
    { 0.8966, 3.7181, 0.0000, 1.1966, -3.9181, -1.1000 },
    { 0.8166, 3.0409, 0.1000, 0.9166, -3.1409, -0.1000 },
    { 0.9333, 2.3545, -0.2000, 0.8333, -2.3545, 0.0000 },
    { 0.9099, 2.5000, 0.0000, 0.9099, -2.3000, 0.0000 },
    { 0.8499, 2.5227, -0.2000, 0.8499, -2.6227, -0.3000 },
    { 0.9933, 2.5590, 0.0000, 0.9933, -2.5590, 0.1000 },
    { 0.5266, -0.6772, 1.3000, 0.5266, -1.9227, 0.8000 },
    { 0.2533, 1.5818, -0.2000, 0.2533, -1.1818, -0.1000 },
    { 0.4733, 4.0772, 1.3000, 0.3733, -1.0772, 0.0000 },
    { 0.9933, 2.4636, 0.0000, 0.8933, -2.5636, 0.0000 },
    { 1.0266, 2.9499, -0.2000, 0.7266, -2.8499, -0.1000 },
    { 0.8899, 2.4909, -0.1000, 0.8900, -2.5909, -0.1000 },
    { 0.8199, 2.4181, -0.2000, 0.8199, -3.1181, -0.2000 },
    { 0.7766, 2.3272, 0.0000, 1.1100, -7.9772, 0.0000 },
    { 1.0900, 7.6409, 0.0000, 1.0900, -7.5409, 0.0000 },
    { 0.8333, 2.0590, 0.0000, 0.8333, -1.7590, 0.0000 },
    { 0.9633, 2.6590, -0.1000, 1.0633, -2.7590, -0.1000 },
    { 0.6566, 2.2499, -0.2000, 0.7566, -2.2499, 0.1000 },
    { 0.9266, 2.6090, -0.1000, 0.7266, -3.0090, -0.1000 },
    { 0.7933, 2.3045, 0.1000, 0.9933, -2.7045, 0.0000 },
    { 0.7366, 3.6454, -0.2000, 0.9366, -4.2454, -0.8000 },
    { 0.5299, 1.7863, 0.0000, 0.8300, -2.0863, -0.4000 },
    { 0.9566, 2.5636, 0.0000, 1.0566, -2.6636, 0.0000 },
    { 0.9299, 2.5545, 0.0000, 0.9299, -2.6545, 0.1000 },
    { 1.3933, 11.0999, 0.0000, 1.3933, -11.0999, 0.0000 },
    { 0.9000, 2.5136, 0.0000, 0.9000, -2.5136, 0.0000 },
    { 0.9466, 2.5772, -0.2000, 0.9466, -2.6772, -0.2000 },
    { 0.9866, 2.5545, -0.1000, 0.9866, -3.0545, 0.0000 },
    { 0.9833, 3.0545, 0.3000, 1.1833, -2.8545, 0.3000 },
    { 9.5799, 10.6772, 0.0000, 9.5799, -10.6772, 0.0000 },
    { 1.0933, 2.5045, 0.1000, 1.0933, -2.9045, 0.1000 },
    { 0.7666, 2.2318, 0.0000, 0.6666, -2.4318, -0.2000 },
    { 1.0199, 2.5954, 0.5000, 1.1200, -2.8954, 0.6000 },
    { 1.1200, 2.4454, 0.7000, 1.1200, -2.7454, 0.7000 },
    { 0.9433, 2.0863, 0.0000, 0.9433, -2.3863, 0.2000 },
    { 0.7599, 2.3909, 0.0000, 0.8600, -2.2909, 0.2000 },
    { 0.9733, 2.3545, -0.0000, 0.8733, -2.1545, 0.1000 },
    { 0.8333, 2.6363, -0.1000, 0.9333, -2.6363, 0.0000 },
    { 0.8533, 2.4136, 0.0000, 0.8533, -2.3136, 0.1000 },
    { 1.1299, 8.4636, 0.0000, 1.1299, -8.4636, 0.0000 },
    { 0.2899, 0.6409, 0.0000, 0.2899, -0.6409, 0.0000 },
    { 0.7766, 2.0909, 0.0000, 0.8766, -1.8909, 0.0000 },
    { 0.9366, 2.7363, 0.0000, 0.9366, -2.9363, 0.0000 },
    { 1.0033, 2.9136, -0.2000, 1.0033, -3.0136, -0.2000 },
    { 0.4033, 2.1954, 0.0000, 0.2033, -1.4954, 0.0000 },
    { 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000 },
    { 0.7766, 2.3272, 0.0000, 1.1566, -9.5772, 0.0000 },
    { 0.5233, 1.0590, 0.0000, 0.5233, -1.0590, 0.0000 },
    { 0.3533, 0.8681, -0.1000, 0.3533, -1.0681, -0.1000 },
    { 0.8766, 3.1545, -0.4000, 0.8766, -3.3545, -0.4000 },
    { 0.5400, 1.7499, -0.2000, 0.5400, -1.2499, -0.2000 },
    { 0.9300, 2.3500, 0.1000, 0.8299, -2.7499, 0.0000 },
    { 1.0066, 2.3909, -0.2000, 1.0066, -3.1909, 0.0000 },
    { 20.8299, 27.9272, 0.0000, 0.0000, 0.0000, 0.0000 },
    { 1.1500, 4.3590, -0.2000, 1.1500, -5.4590, -0.5000 },
    { 0.9233, 2.3227, 0.0000, 1.0233, -2.8227, 0.1000 },
    { 0.7866, 2.6227, -0.2000, 1.0866, -2.8227, 0.0000 },
    { 0.2333, 1.1181, 0.0000, 0.2333, -1.1181, 0.0000 },
    { 0.9133, 2.5818, -0.1000, 0.9133, -3.3818, 0.1000 },
    { 0.6566, 1.4636, 0.3000, 0.5566, -1.6636, 0.4000 },
    { 1.1833, 7.2318, 0.0000, 1.1833, -7.2318, 0.0000 },
    { 1.0133, 2.8681, 0.1000, 0.9133, -3.0681, 0.2000 },
    { 0.2333, 1.2727, 0.0000, 0.2333, -1.2727, 0.0000 },
    { 0.9699, 2.1181, -0.3000, 1.0699, -2.5181, 0.1000 },
    { 1.0266, 3.4181, 0.4000, 1.0266, -4.0181, -0.3000 },
    { 0.7533, 2.4136, 0.1000, 0.8533, -2.3136, 0.4000 },
    { 1.1466, 8.3636, 0.0000, 1.1466, -8.3636, 0.0000 },
    { 1.0600, 6.1954, 0.0000, 1.0600, -6.1954, 0.0000 },
    { 14.8166, 26.1681, 0.0000, 14.8166, -26.1681, 0.0000 },
    { 4.1966, 6.1590, 0.0000, 4.1966, -6.1590, 0.0000 },
    { 0.1666, 0.4181, 0.0000, 0.1666, -0.4181, 0.0000 },
    { 0.9499, 6.1227, 0.0000, 0.9499, -6.1227, 0.0000 },
    { 1.0033, 2.2863, 0.0000, 0.9033, -2.6863, 0.0000 },
    { 1.0033, 2.2863, 0.0000, 0.9033, -2.6863, 0.0000 },
    { 1.0033, 2.3318, 0.0000, 0.9033, -2.7318, 0.0000 },
    { 1.0733, 2.6000, 0.0000, 1.1733, -2.6000, 0.1000 },
    { 0.8000, 2.7545, -0.1000, 1.0000, -2.7545, 0.1000 },
    { 0.8266, 3.1636, 0.5000, 1.0266, -3.0636, 0.9000 },
    { 0.8733, 2.1181, 0.0000, 0.8733, -2.6181, -0.3000 },
    { 0.8800, 2.5590, -0.2000, 0.8800, -2.6590, -0.1000 },
    { 0.8433, 2.6045, 0.1000, 1.0433, -2.8045, 0.0000 },
    { 0.7933, 2.3045, 0.0000, 0.9933, -2.7045, 0.0000 },
    { 0.9766, 1.5363, 0.0000, 0.9766, -1.5363, 0.0000 },
    { 1.0066, 1.4818, 0.0000, 1.0066, -1.4818, 0.0000 },
    { 0.4833, 2.1136, 0.0000, 0.4833, -2.1136, 0.0000 },
    { 0.8666, 3.0999, 0.2000, 0.9666, -3.0999, 0.3000 },
    { 0.8266, 0.6499, 0.0000, 0.8266, -0.6499, 0.0000 },
    { 0.7100, 1.4363, 0.0000, 0.7100, -1.4363, 0.0000 }
};


stock VehicleLights:mode(vehicleid, light) {
    if (vehicleid < 0 || vehicleid >= MAX_VEHICLES) return 1;
    if (IsValidDynamicObject(VehicleLights:data[vehicleid][VehicleLights:objects][0])) DestroyDynamicObjectEx(VehicleLights:data[vehicleid][VehicleLights:objects][0]);
    VehicleLights:data[vehicleid][VehicleLights:objects][0] = -1;
    if (IsValidDynamicObject(VehicleLights:data[vehicleid][VehicleLights:objects][1])) DestroyDynamicObjectEx(VehicleLights:data[vehicleid][VehicleLights:objects][1]);
    VehicleLights:data[vehicleid][VehicleLights:objects][1] = -1;
    if (IsValidDynamicObject(VehicleLights:data[vehicleid][VehicleLights:objects][2])) DestroyDynamicObjectEx(VehicleLights:data[vehicleid][VehicleLights:objects][2]);
    VehicleLights:data[vehicleid][VehicleLights:objects][2] = -1;
    if (IsValidDynamicObject(VehicleLights:data[vehicleid][VehicleLights:objects][3])) DestroyDynamicObjectEx(VehicleLights:data[vehicleid][VehicleLights:objects][3]);
    VehicleLights:data[vehicleid][VehicleLights:objects][3] = -1;
    new modelid = GetVehicleModel(vehicleid);
    if (!IsValidVehicleModelID(modelid)) return 1;
    new model = modelid - 400;
    VehicleLights:data[vehicleid][VehicleLights:status] = 0;
    if (light == VehicleLights:Turn_All_Lights) {
        VehicleLights:data[vehicleid][VehicleLights:objects][0] = CreateDynamicObject(19294, 0, 0, 0, 0, 0, 0);
        VehicleLights:data[vehicleid][VehicleLights:objects][1] = CreateDynamicObject(19294, 0, 0, 0, 0, 0, 0);
        VehicleLights:data[vehicleid][VehicleLights:objects][2] = CreateDynamicObject(19294, 0, 0, 0, 0, 0, 0);
        VehicleLights:data[vehicleid][VehicleLights:objects][3] = CreateDynamicObject(19294, 0, 0, 0, 0, 0, 0);
        AttachDynamicObjectToVehicle(VehicleLights:data[vehicleid][VehicleLights:objects][0], vehicleid, -VehicleLights:LightsPos[model][0], VehicleLights:LightsPos[model][1], VehicleLights:LightsPos[model][2], 0, 0, 0);
        AttachDynamicObjectToVehicle(VehicleLights:data[vehicleid][VehicleLights:objects][1], vehicleid, -VehicleLights:LightsPos[model][3], VehicleLights:LightsPos[model][4], VehicleLights:LightsPos[model][5], 0, 0, 0);
        AttachDynamicObjectToVehicle(VehicleLights:data[vehicleid][VehicleLights:objects][2], vehicleid, VehicleLights:LightsPos[model][0], VehicleLights:LightsPos[model][1], VehicleLights:LightsPos[model][2], 0, 0, 0);
        AttachDynamicObjectToVehicle(VehicleLights:data[vehicleid][VehicleLights:objects][3], vehicleid, VehicleLights:LightsPos[model][3], VehicleLights:LightsPos[model][4], VehicleLights:LightsPos[model][5], 0, 0, 0);
        GetVehicleZAngle(vehicleid, VehicleLights:data[vehicleid][VehicleLights:vehicleangle]);
        VehicleLights:data[vehicleid][VehicleLights:status] = 2;
        VehicleLights:data[vehicleid][VehicleLights:time] = gettime();
    }
    if (light == VehicleLights:Turn_Left_Lights) {
        VehicleLights:data[vehicleid][VehicleLights:objects][0] = CreateDynamicObject(19294, 0, 0, 0, 0, 0, 0);
        VehicleLights:data[vehicleid][VehicleLights:objects][1] = CreateDynamicObject(19294, 0, 0, 0, 0, 0, 0);
        AttachDynamicObjectToVehicle(VehicleLights:data[vehicleid][VehicleLights:objects][0], vehicleid, -VehicleLights:LightsPos[model][0], VehicleLights:LightsPos[model][1], VehicleLights:LightsPos[model][2], 0, 0, 0);
        AttachDynamicObjectToVehicle(VehicleLights:data[vehicleid][VehicleLights:objects][1], vehicleid, -VehicleLights:LightsPos[model][3], VehicleLights:LightsPos[model][4], VehicleLights:LightsPos[model][5], 0, 0, 0);
        GetVehicleZAngle(vehicleid, VehicleLights:data[vehicleid][VehicleLights:vehicleangle]);
        VehicleLights:data[vehicleid][VehicleLights:status] = 1;
        VehicleLights:data[vehicleid][VehicleLights:time] = gettime();
    }
    if (light == VehicleLights:Turn_Right_Lights) {
        DestroyDynamicObjectEx(VehicleLights:data[vehicleid][VehicleLights:objects][2]);
        DestroyDynamicObjectEx(VehicleLights:data[vehicleid][VehicleLights:objects][3]);
        VehicleLights:data[vehicleid][VehicleLights:objects][2] = CreateDynamicObject(19294, 0, 0, 0, 0, 0, 0);
        VehicleLights:data[vehicleid][VehicleLights:objects][3] = CreateDynamicObject(19294, 0, 0, 0, 0, 0, 0);
        AttachDynamicObjectToVehicle(VehicleLights:data[vehicleid][VehicleLights:objects][2], vehicleid, VehicleLights:LightsPos[model][0], VehicleLights:LightsPos[model][1], VehicleLights:LightsPos[model][2], 0, 0, 0);
        AttachDynamicObjectToVehicle(VehicleLights:data[vehicleid][VehicleLights:objects][3], vehicleid, VehicleLights:LightsPos[model][3], VehicleLights:LightsPos[model][4], VehicleLights:LightsPos[model][5], 0, 0, 0);
        GetVehicleZAngle(vehicleid, VehicleLights:data[vehicleid][VehicleLights:vehicleangle]);
        VehicleLights:data[vehicleid][VehicleLights:status] = 1;
        VehicleLights:data[vehicleid][VehicleLights:time] = gettime();
    }
    return 1;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys) {
    if (!IsPlayerInAnyVehicle(playerid)) return 1;
    new vehicleid = GetPlayerVehicleID(playerid);
    if (newkeys == KEY_ANALOG_UP) {
        if (gettime() - VehicleLights:playerdata[playerid] <= 2) return 1;
        VehicleLights:playerdata[playerid] = gettime();
        if (VehicleLights:data[vehicleid][VehicleLights:status] == 2) VehicleLights:mode(vehicleid, VehicleLights:Turn_Off_All_Lights);
        else VehicleLights:mode(vehicleid, VehicleLights:Turn_All_Lights);
        return 1;
    }
    if (newkeys == KEY_ANALOG_LEFT && VehicleLights:data[vehicleid][VehicleLights:status] != 2) {
        if (gettime() - VehicleLights:playerdata[playerid] <= 2) return 1;
        VehicleLights:playerdata[playerid] = gettime();
        if (VehicleLights:data[vehicleid][VehicleLights:status] == 1) VehicleLights:mode(vehicleid, VehicleLights:Turn_Off_All_Lights);
        else VehicleLights:mode(vehicleid, VehicleLights:Turn_Left_Lights);
        return 1;
    }
    if (newkeys == KEY_ANALOG_RIGHT && VehicleLights:data[vehicleid][VehicleLights:status] != 2) {
        if (gettime() - VehicleLights:playerdata[playerid] <= 2) return 1;
        VehicleLights:playerdata[playerid] = gettime();
        if (VehicleLights:data[vehicleid][VehicleLights:status] == 1) VehicleLights:mode(vehicleid, VehicleLights:Turn_Off_All_Lights);
        else VehicleLights:mode(vehicleid, VehicleLights:Turn_Right_Lights);
        return 1;
    }
    return 1;
}

hook OnPlayerExitVehicle(playerid, vehicleid) {
    VehicleLights:mode(vehicleid, VehicleLights:Turn_Off_All_Lights);
    return 1;
}

hook OnPlayerEnterVehicle(playerid, vehicleid, ispassenger) {
    VehicleLights:mode(vehicleid, VehicleLights:Turn_Off_All_Lights);
    return 1;
}

hook OnVehicleDeath(vehicleid, killerid) {
    VehicleLights:mode(vehicleid, VehicleLights:Turn_Off_All_Lights);
    return 1;
}

hook OnPlayerUpdate(playerid) {
    if (!IsPlayerInAnyVehicle(playerid)) return 1;
    new vehicleid = GetPlayerVehicleID(playerid);
    if (VehicleLights:data[vehicleid][VehicleLights:status] != 1) return 1;
    new Float:zangle;
    GetVehicleZAngle(vehicleid, zangle);
    if (gettime() - VehicleLights:data[vehicleid][VehicleLights:time] > 15) VehicleLights:mode(vehicleid, VehicleLights:Turn_Off_All_Lights);
    return 1;
}