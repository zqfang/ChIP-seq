library(rGREAT)
bedUp="./bet_macs_q0.01.time.S21K_Untreated_vs_Ctrl_Untreated/S21K_Untreated_vs_Ctrl_Untreated_uptarget_associate_peaks.GREAT.input.bed"
bedDw="./bet_macs_q0.01.time.S21K_Untreated_vs_Ctrl_Untreated/S21K_Untreated_vs_Ctrl_Untreated_downtarget_associate_peaks.GREAT.input.bed"
bedUpdf = read.table(bedUp, header = F)
bedDwdf = read.table(bedDw, header = F)
jobUp = submitGreatJob(bedUpdf)
jobDw = submitGreatJob(bedDwdf)

tbUp = getEnrichmentTables(jobUp)
tbDw = getEnrichmentTables(jobDw)

lenGO = length(names(tbUp))
# > names(tbUp)
# [1] "GO Molecular Function" "GO Biological Process" "GO Cellular Component"

for(g in 1:lenGO ) {
  godb = names(tbUp)[g]
  tbg1 = tbUp[[g]]
  tbg2 = tbDw[[g]]
  write.table(tbg1, file=paste0("SOX21.KO.targetgenes.up.GREAT.", godb,".txt"))
  write.table(tbg2, file=paste0("SOX21.KO.targetgenes.down.GREAT.", godb,".txt"))
              
  
}

par(mfrow = c(1, 3))
res = plotRegionGeneAssociationGraphs(jobUp)

