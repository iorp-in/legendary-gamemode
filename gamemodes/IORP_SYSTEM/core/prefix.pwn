//database tables
#define SettingsTable "settings"

// Email Service
#define ALERT_TYPE_WHATSAPP "WHATSAPP_ALERT"
#define ALERT_TYPE_SERVER "SERVER_ALERT"
#define ALERT_TYPE_LOGIN "LOGIN_ALERT"
#define ALERT_TYPE_ACCOUNT "ACCOUNT_ALERT"
#define ALERT_TYPE_FACTION "FACTION_ALERT"
#define ALERT_TYPE_PROPERTY_EXPIRE "PROPERTY_EXPIRE_ALERT"

// vault id collection
#define Vault_Transaction_Vault_To_Vault 0
#define Vault_Transaction_Cash_To_Vault 1
#define Vault_Transaction_Vault_To_Cash 2
#define Vault_Transaction_Bank_To_Vault 3
#define Vault_Transaction_Vault_To_Bank 4
#define Vault_ID_Government 0
#define Vault_ID_IndianOIL 1
#define Vault_ID_SAPD 2
#define Vault_ID_Mechanics 8
#define Vault_ID_TAX 9
#define Vault_ID_DUMP_MONEY 10

// faction ids
#define FACTION_ID_SAGD 0
#define FACTION_ID_SAAF 1
#define FACTION_ID_SAPD 2
#define FACTION_ID_SWAT 3
#define FACTION_ID_SAND 4
#define FACTION_ID_CF 5
#define FACTION_ID_SAMD 6
#define FACTION_ID_CMC 7
#define FACTION_ID_GSF 8
#define FACTION_ID_BM 9
#define FACTION_ID_CMB 10
#define FACTION_ID_DOM 11
#define FACTION_ID_SATD 12
#define FACTION_ID_IOPL 13

#define Medice_Oral_antihistamines 0
#define Medice_Ditropan_XL 1
#define Medice_Benzodiazepines 2
#define Medice_Temazepam 3
#define Medice_Bismuth_Subsalicylate 4

#define Shop_Type_Farming_Resources 0
#define Shop_Type_Farming_Seeds 1
#define Shop_Type_General_Items 2
#define Shop_Type_Material_Items 3
#define Shop_Type_Electronic 4
#define Shop_Type_Clinic 5
#define Shop_Type_Firework 6
#define Shop_Type_Weapons 7
#define Shop_Type_Sex_Toy 8
#define Shop_Type_Clothes 9
#define Shop_Type_Dealership_LightMotor 10
#define Shop_Type_Dealership_HeavyMotor 11
#define Shop_Type_Dealership_TwoWheelerMotor 12
#define Shop_Type_Dealership_HelicopterMotor 13
#define Shop_Type_Dealership_PlaneMotor 14
#define Shop_Type_Dealership_BoatMotor 15
#define Shop_Type_Clothe_Accessories 16
#define Shop_Type_Garage 17

#define FlexDialog:%0(%1) forward FlD@%0(%1); public FlD@%0(%1)

//bitcoin
#define BitCoin:%0 BtC@
#define BtC@OnInit(%0) hook BitCoinOnInit(%0)
#define BtC@OnResponse(%0) hook BitCoinOnResponse(%0)

//ucp
#define UCP:%0 Ucp@
#define Ucp@OnInit(%0) hook UcpOnInit(%0)
#define Ucp@OnResponse(%0) hook UcpOnResponse(%0)

//acp
#define ACP:%0 Acp@
#define Acp@OnInit(%0) hook AcpOnInit(%0)
#define Acp@OnResponse(%0) hook AcpOnResponse(%0)

//ascp
#define ASCP:%0 Ascp@
#define Ascp@OnInit(%0) hook AscpOnInit(%0)
#define Ascp@OnResponse(%0) hook AscpOnResponse(%0)

//apcp
#define APCP:%0 Apcp@
#define Apcp@OnInit(%0) hook ApcpOnInit(%0)
#define Apcp@OnResponse(%0) hook ApcpOnResponse(%0)

//scp
#define SCP:%0 Scp@
#define Scp@OnInit(%0) hook ScpOnInit(%0)
#define Scp@OnResponse(%0) hook ScpOnResponse(%0)

//vcp
#define VCP:%0 Vcp@
#define Vcp@OnInit(%0) hook VcpOnInit(%0)
#define Vcp@OnResponse(%0) hook VcpOnResponse(%0)

//QuickActions
#define QuickActions:%0 QukActs@
#define QukActs@OnInit(%0) hook QuickActionsOnInit(%0)
#define QukActs@OnResponse(%0) hook QuickActionsOnResponse(%0)

//doc
#define Doc:%0 Doc@
#define Doc@OnResponse(%0) hook DocOnResponse(%0)

//truck
#define DTruck:%0 DTruck@
#define DTruck@OnInit(%0) hook DTruckOnInit(%0)
#define DTruck@OnResponse(%0) hook DTruckOnResponse(%0)


// vehicle trunk
#define VTrunk:%0 VTrunk@
#define VTrunk@OnInit(%0) hook VTrunkOnInit(%0)
#define VTrunk@OnResponse(%0) hook VTrunkOnResponse(%0)


// prefix collection
#define Database:%0 DaBa@
#define Discord:%0 Discord@
#define Credit:%0 Credit@
#define Disease:%0 DiSe@
#define operation:%0 MOpS@
#define stretcher:%0 StCh@
#define Dialog:%0 DiLg@
#define acp:%0 acp@
#define mechanic:%0 meca@
#define vault:%0 vA@
#define OilCompany:%0 Ol@
#define PumpBusiness:%0 PbS@
#define InformationTag:%0 ItS@
#define Whatsapp:%0 SmS@
#define Farm:%0 FaRm@
#define Hotel:%0 HoTe@
#define SeedMarket:%0 SmK@
#define MafiaZoneSystem:%0 MzC@
#define Heist:%0 HsT@
#define FlashZone:%0 FzD@
#define PRadio:%0 pRf@
#define ResourceStorageBusiness:%0 rSBs@
#define TrailerStorage:%0 tRl@
#define Timeline:%0 TmL@
#define WeaponLicense:%0 WlS@
#define WeaponSpecialistDegree:%0 WsD@
#define PM:%0 PM@
#define FoodStall:%0 FsL@
#define DynamicShopBusiness:%0 DsB@
#define DynamicShopBusinessItem:%0 CStF@
#define VehicleLights:%0 Vlis@
#define MaterialReselling:%0 MtRsG@
#define Shipment:%0 ShPs@
#define SelfJail:%0 SfJl@
#define EasterEgg:%0 EsEg@
#define Debt:%0 DbtS@
#define Backpack:%0 BaCpA@
#define PersonalVehicle:%0 PvEx@
#define House:%0 House@
#define Family:%0 FaMl@
#define ModShop:%0 MoDs@
#define Camp:%0 CaMp@
#define Spectate:%0 SpCt@
#define SprayTag:%0 SpTg@
#define SnakeGame:%0 SnkGm@
#define Race:%0 ReSm@
#define AadhaarCard:%0 AdCard@
#define Bank:%0 Bank@
#define Debug:%0 Dbg@
#define Shop:%0 Shop@
#define AirTransport:%0 TrnS@
#define Email:%0 Email@
#define Patch:%0 Patch@
#define Event:%0 Event@
#define Faction:%0 Faction@
#define FactionObject:%0 FcToBj@
#define BetaTester:%0 BtTsT@
#define FuelAuth:%0 FuAuT@
#define Course:%0 Course@
#define StaticVehicle:%0 StCvEl@
#define XenonMod:%0 XeNmD@
#define CameraInterpolate:%0 CmRnTe@
#define GunDrop:%0 FpGnI@
#define InvicableAuth:%0 InvAuth@
#define InvisibleAuth:%0 IviSAuth@
#define NameTagAuth:%0 NmTg@
#define WantedDatabase:%0 WnTDs@
#define Entrance:%0 EntRs@
#define HintMessages:%0 HnTMs@
#define MapIcons:%0 MpCnS@
#define DynamicActors:%0 DcAcR@
#define GPS:%0 GpsS@
#define DynamicGate:%0 DyGsT@
#define DJ:%0 DjSt@
#define NuclearLaunchSite:%0 NlS@
#define HitMarket:%0 HtM@
#define PUBG:%0 PbG@
#define COD:%0 CoD@
#define VehicleHalloweenMode:%0 VehHalWnMd@
#define Refund:%0 RfnD@
#define RegisterHacking:%0 RegHk@
#define SafeHacking:%0 SfHk@
#define Motive:%0 Mtv@
#define Anim:%0 AnTs@
#define Mine:%0 Mine@
#define Crate:%0 Crate@
#define EtShop:%0 EtShop@
#define Drug:%0 Drug@
#define ContactList:%0 CoLs@
#define Phone:%0 Phone@
#define Sumo:%0 Sumo@
#define Roleplay:%0 RpN@
#define PoliceInfernus:%0 PlInf@
#define UnknownCommand:%0 UknCmd@
#define BloodTextDraw:%0 BlTdw@