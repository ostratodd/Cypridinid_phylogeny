rm pep/*.fa
#note files with .fa are downloaded from genbank
#others are translated in untranslated directory
#those end in .pep and are not messed with here

./download_data.pl data_table.tab 50

perl -p -i -e 's/\>/\>AltLiz_/g' pep/Australia_Alternochelata_lizardensis__AltLiz.fa
perl -p -i -e 's/\>/\>LongWhiteEye_/g' pep/Australia_CYPRIDINIDAE1__LongWhiteEye.fa
perl -p -i -e 's/\>/\>LIRSCyp2_/g' pep/Australia_CYPRIDINIDAE2__LIRSCyp2.fa
perl -p -i -e 's/\>/\>LIRSCyp1_/g' pep/Australia_CYPRIDINIDAE3__LIRSCyp1.fa
perl -p -i -e 's/\>/\>FatWhiteEye_/g' pep/Australia_CYPRIDINIDAE__FatWhiteEye.fa
perl -p -i -e 's/\>/\>Chlorica_/g' pep/Australia_Chelicopia_lorica__Chlorica.fa
perl -p -i -e 's/\>/\>WhiteVanessaLIRS_/g' pep/Australia_Cypridinodes_Cypridinid5__WhiteVanessaLIRS.fa
perl -p -i -e 's/\>/\>Euph_microasciformis_/g' pep/Australia_Euphilomedes_microasciformis__Euph_microasciformis.fa
perl -p -i -e 's/\>/\>Harb_slatteryi_/g' pep/Australia_Harbansus_slatteryi__Harb_slatteryi.fa
perl -p -i -e 's/\>/\>GlovSkog_/g' pep/Belize-Glovers_Skogsbergia_sp__GlovSkog.fa
perl -p -i -e 's/\>/\>BothMSH_/g' pep/Belize_HGroup_MSH__BothMSH.fa
perl -p -i -e 's/\>/\>Korn_hast_c_/g' pep/Belize_Kornickeria_hastingsi_carriebowae__Korn_hast_c.fa
perl -p -i -e 's/\>/\>BothSVD_/g' pep/Belize_Maristella_SVD__BothSVD.fa
perl -p -i -e 's/\>/\>AllBzSVU_/g' pep/Belize_Maristella_SVU__AllBzSVU.fa
perl -p -i -e 's/\>/\>AllBzVAD_/g' pep/Belize_Maristella_VAD__AllBzVAD.fa
perl -p -i -e 's/\>/\>Gruber_Pannecohenae_/g' pep/Belize_Photeros_annecohenae__Gruber_Pannecohenae.fa
perl -p -i -e 's/\>/\>BothPmorini_/g' pep/Belize_Photeros_morini__BothPmorini.fa
perl -p -i -e 's/\>/\>Gigantocypris_/g' pep/California_Gigantocypris_sp__Gigantocypris.fa
perl -p -i -e 's/\>/\>Vtsu_/g' pep/California_Vargula_tsujii__Vtsu.fa
perl -p -i -e 's/\>/\>curacao_/g' pep/Curacao_Curacao_Kornickeria__curacao.fa
perl -p -i -e 's/\>/\>Cylindroleberidinae_/g' pep/Harvard_Cylindroleberidinae__Cylindroleberidinae.fa
perl -p -i -e 's/\>/\>BothJaJimGun_/g' pep/Jamaica_Jimmorinia_gunnari__BothJaJimGun.fa
perl -p -i -e 's/\>/\>JaAU_S56_/g' pep/Jamaica_Maristella_AU__JaAU_S56.fa
perl -p -i -e 's/\>/\>BothJaLSZZ_/g' pep/Jamaica_Maristella_LSZZ__BothJaLSZZ.fa
perl -p -i -e 's/\>/\>BothJaOBD_/g' pep/Jamaica_Maristella_OBD__BothJaOBD.fa
perl -p -i -e 's/\>/\>BothJaSVD_/g' pep/Jamaica_Maristella_SVD__BothJaSVD.fa
perl -p -i -e 's/\>/\>BothJaVAD_/g' pep/Jamaica_Maristella_VAD__BothJaVAD.fa
perl -p -i -e 's/\>/\>JaWLU_S67_/g' pep/Jamaica_Maristella_WLU__JaWLU_S67.fa
perl -p -i -e 's/\>/\>JaWTF_S54_/g' pep/Jamaica_Maristella_WTF__JaWTF_S54.fa
perl -p -i -e 's/\>/\>BothJamescasei_/g' pep/Jamaica_Photeros_jamescasei__BothJamescasei.fa
perl -p -i -e 's/\>/\>Allmacelroy_/g' pep/Jamaica_Photeros_macelroy__Allmacelroy.fa
perl -p -i -e 's/\>/\>jpcyp2b_/g' pep/Japan_Cypridinid6__jpcyp2b.fa
perl -p -i -e 's/\>/\>Jp_Melavar22_/g' pep/Japan_Melavargula_japonica__Jp_Melavar22.fa
perl -p -i -e 's/\>/\>BothPara_w_/g' pep/Japan_Paravargula_maculosa__BothPara_w.fa
perl -p -i -e 's/\>/\>Vhilg_/g' pep/Japan_Vargula_hilgendorfii__Vhilg.fa
perl -p -i -e 's/\>/\>BothVhilg_shim_/g' pep/Japan_Vargula_hilgendorfii_shimoda__BothVhilg_shim.fa
perl -p -i -e 's/\>/\>PSKO_/g' pep/Panama_Panama_Skogsbergia__PSKO.fa
perl -p -i -e 's/\>/\>PMMFU_/g' pep/Panama_Panama_ZGroup__PMMFU.fa
perl -p -i -e 's/\>/\>RO-AG_S10_/g' pep/Roatan_Maristella_AG__RO-AG_S10.fa
perl -p -i -e 's/\>/\>BothRoCMU_/g' pep/Roatan_Maristella_CMU__BothRoCMU.fa
perl -p -i -e 's/\>/\>AllRoDU_/g' pep/Roatan_Maristella_DU__AllRoDU.fa
perl -p -i -e 's/\>/\>RoIR_S66_/g' pep/Roatan_Maristella_IR__RoIR_S66.fa
perl -p -i -e 's/\>/\>BothRoODH_/g' pep/Roatan_Maristella_ODH__BothRoODH.fa
perl -p -i -e 's/\>/\>AllRoRD_/g' pep/Roatan_Maristella_RD__AllRoRD.fa
perl -p -i -e 's/\>/\>BothGPH_/g' pep/Roatan_Photeros_GPH__BothGPH.fa
perl -p -i -e 's/\>/\>ROWLU_2018_/g' pep/Roatan_Photeros_WLU__ROWLU_2018.fa

rm -rf OrthoFinder_results	#remove old results
ulimit -n 3236
orthofinder -t 4 -I 2.1 -M msa -T fasttree -f ./pep -o ./OrthoFinder_results
