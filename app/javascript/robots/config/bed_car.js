// Hardcoded for the moment because the calculation logic is a pain.
const Barcodes = [
'580000000793', '580000001806', '580000002810', '580000003824',
'580000004838', '580000005842', '580000006856', '580000007860',
'580000008874', '580000009659', '580000010815', '580000011829',
'580000012833', '580000013847', '580000014851', '580000015865',
'580000016879', '580000017654', '580000018668', '580000019672',
'580000020838', '580000021842', '580000022856', '580000023860',
'580000024874', '580000025659', '580000026663', '580000027677',
'580000028681', '580000029695', '580000030851', '580000031865',
'580000032879', '580000033654', '580000034668', '580000035672',
'580000036686', '580000037690', '580000038703', '580000039717',
'580000040874', '580000041659', '580000042663', '580000043677',
'580000044681', '580000045695', '580000046708', '580000047712',
'580000048726', '580000049730', '580000050668']

const Bed = (number) => {
  return { name: `Bed ${number}`, barcode: Barcodes[number] }
}
const Car = (column, tray) => {
  return { name: `Carousle ${column}:${tray}`, Barcodes[(column*10)+tray] }
}

export { Bed, Car }
