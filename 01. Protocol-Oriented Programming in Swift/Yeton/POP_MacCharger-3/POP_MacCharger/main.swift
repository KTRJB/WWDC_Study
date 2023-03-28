typealias WattPerHour = Int
typealias Watt = Int

//MARK: - Charger
let applewatchCharger = AppleWatchCharger() //5 
let iphoneCharger = IphoneCharger() // 18
let ipadCharger = IPadCharger()  // 30
let defaultMacCharger = DefaultMacBookCharger() // 96
let fastestMacCharger = FastestMacBookCharger() // 106

//MARK: - MacBookList
var yetonMac = MacBook(deviceAllowableChargingWatt: 18, currentChargedBattery: 35)
var jaejaeMac = MacBook(deviceAllowableChargingWatt: 30, currentChargedBattery: 30)
var boryMac = MacBook(deviceAllowableChargingWatt: 10, currentChargedBattery: 30)
var sookoongMac = MacBook(deviceAllowableChargingWatt: 100, currentChargedBattery: 30)

//MARK: - TEST
//yetonMac.chargeBattery(charger: applewatchCharger)
//yetonMac.chargeBattery(charger: iphoneCharger)
//yetonMac.chargeBattery(charger: ipadCharger)
//yetonMac.chargeBattery(charger: defaultMacCharger)
//yetonMac.chargeBattery(charger: fastestMacCharter)
//sookoongMac.chargeBattery(charger: defaultMacCharger)
sookoongMac.chargeBattery(charger: applewatchCharger)
//MARK: - Bag Protocol Test
var gucciBag = Bag()

gucciBag.put(item: yetonMac)
gucciBag.put(item: fastestMacCharger)
gucciBag.put(item: defaultMacCharger)

gucciBag.printCurrentItems()
