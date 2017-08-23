# what is the OUTPUTFILEMCSTUDY for? It's giving errors in pp CrossSection Ratio
# what are central points of analysis?



#!/bin/bash
#source clean.sh
CENTPbPbMIN=0
CENTPbPbMAX=100
#Central point of the analysis

DOANALYSISPP_FONLL=0
DOANALYSISPP_FIT=0
DOANALYSISPP_MCSTUDY=1
DOANALYSISPP_CROSS=0

DOANALYSISPbPb_FIT=0
DOANALYSISPbPb_MCSTUDY=0
DOANALYSISPbPb_CROSS=0
DORAA=0

## PP MONTE CARLO
INPUTMCPP="../../bsTMVACDozen/merged-files/MLP_and_BDT_MC.root"

## PP DATA 
INPUTDATAPP="../../bsTMVACDozen/merged-files/MLP_and_BDT_DATA.root"

## PbPb MONTE CARLO
INPUTMCPbPb="/afs/cern.ch/user/c/cdozen/public/forLuke/loop_Bs0_PbPb_MC_25072017_pthat10.root"

## PbPb DATA 
INPUTDATAPbPb="/data/wangj/Data2015/Bntuple/PbPb/Bntuple_BfinderData_PbPb_20160406_bPt5jpsiPt0tkPt0p8_BpB0BsX_skimhlt.root"

## ANALYSIS PP TRIGGERED
FONLLDATINPUT="fonllInputs/fonllInput.dat"
FONLLOUTPUTFILE="outputBs.root"
OUTPUTFILERAA="ROOTfiles/outputRAA.root"

LABELPP="pp"
LUMIPP=27.4
ISMCPP=0
ISDOWEIGHTPP=0
SELGENPP="TMath::Abs(Gy)<2.4&&abs(GpdgId)==521&&GisSignal==1"

#pp GA
CUTPP="TMath::Abs(By)<2.4&&TMath::Abs(Bmumumass-3.096916)<0.15&&Bmass>5&&Bmass<6&&Btrk1Pt>.687&&Btrk2Pt>.654&&Bchi2cl>.00431&&BsvpvDistance/BsvpvDisErr>3.05&&Bd0/Bd0Err>212&&cos(Bdtheta)>-.232&&Bmu1pt>.88&&Bmu2pt>.589&&Bpt>5.75&&abs(Btktkmass-1.019455)<.0384&&Blxy>-.0106"
RECOONLYPP=$CUTPP

TRGPP="(HLT_HIL1DoubleMu0_v1)"
OUTPUTFILEPP="ROOTfiles/hPtSpectrumBplusPP.root"
OUTPUTFILEMCSTUDYPP="ROOTfiles/MCstudiesPP.root"
OUTPUTFILEPlotPP="ROOTfiles/CrossSectionPP.root"

OUTPUTFILEPbPb="ROOTfiles/hPtSpectrumBplusPbPb.root"

#SETTING for NP fit
NPFIT_PP="3.12764e1*TMath::Gaus(x,5.33166,3.64663e-2)*(x<5.33166)+(x>=5.33166)*3.12764e1*TMath::Gaus(x,5.33166,1.5204e-1)+2.11124e2*TMath::Erf(-(x-5.14397)/6.43194e-2) + 2.11124e2"

if [ $DOANALYSISPP_FONLL -eq 1 ]; then      
root -l -b -q Bsdsigmadpt.cc
fi 

echo "-------------------------------------------------------------------------"

if [ $DOANALYSISPP_FIT -eq 1 ]; then      
g++ fitBs.C $(root-config --cflags --libs) -g -o fitBs.exe 
./fitBs.exe 0 "$INPUTDATAPP"  "$INPUTMCPP"  "$TRGPP" "$CUTPP"   "$SELGENPP"   "$ISMCPP"   1   "$ISDOWEIGHTPP"   "$LABELPP"  "$OUTPUTFILEPP" "$NPFIT_PP" 0
rm fitBs.exe
fi 

echo "-------------------------------------------------------------------------"

if [ $DOANALYSISPP_MCSTUDY -eq 1 ]; then      
g++ MCefficiency.C $(root-config --cflags --libs) -g -o MCefficiency.exe 
./MCefficiency.exe  0 "$INPUTMCPP"  "$SELGENPP" "$SELGENPPACCPP"  "$RECOONLYPP" "$CUTPP&&$TRGPPMC"  "$LABELPP" "$OUTPUTFILEMCSTUDYPP" "$ISDOWEIGHTPP" "$CENTPbPbMIN" "$CENTPbPbMAX"
rm MCefficiency.exe
fi

echo "-------------------------------------------------------------------------"

if [ $DOANALYSISPP_CROSS -eq 1 ]; then      
g++ CrossSectionRatio.C $(root-config --cflags --libs) -g -o CrossSectionRatio.exe 
./CrossSectionRatio.exe "$FONLLOUTPUTFILE"  "$OUTPUTFILEPP" "$OUTPUTFILEMCSTUDYPP" "$OUTPUTFILEPlotPP" 0 "$LABELPP" 0 "$LUMIPP"
rm CrossSectionRatio.exe
fi

echo "-------------------------------------------------------------------------"

LABELPbPb="PbPb"

LUMIPbPb=13.14

ISMCPbPb=0
ISDOWEIGHTPbPb=0
SELGENPbPb="TMath::Abs(Gy)<2.4&&abs(GpdgId)==521&&GisSignal==1"

#GA
CUTPbPb="TMath::Abs(By)<2.4&&abs(Bmumumass-3.096916)<0.15&&Bmass>5.&&Bmass<6.&&Btrk1Pt>1.5&&Btrk2Pt>1.5&&Bchi2cl>0.1&&(Bd0/Bd0Err)>5.&&cos(Bdtheta)>0.8&&Bmu1pt>1.5&&Bmu2pt>1.5&&Bpt>15.0&&TMath::Abs(Btktkmass-1.019455)<0.05&&Blxy>0.1"
RECOONLYPbPb="1"

TRGPbPb="(HLT_HIL1DoubleMu0_v1 || HLT_HIL1DoubleMu0_part1_v1 || HLT_HIL1DoubleMu0_part2_v1 || HLT_HIL1DoubleMu0_part3_v1)"
OUTPUTFILEMCSTUDYPbPb="ROOTfiles/MCstudiesPbPb.root"
OUTPUTFILEPlotPbPb="ROOTfiles/CrossSectionPbPb.root"

#SETTING for NP fit
NPFIT_PbPb="3.39711e1*TMath::Gaus(x,5.35002e0,3.87952e-2)*(x<5.35002e0)+(x>=5.35002e0)*3.39711e1*TMath::Gaus(x,5.35002e0,1.14232e-1)+2.16376e2*TMath::Erf(-(x-5.14189)/8.66243e-2) + 2.16376e2"

if [ $DOANALYSISPbPb_FIT -eq 1 ]; then      
g++ fitBs.C $(root-config --cflags --libs) -g -o fitBs.exe 
./fitBs.exe 1 "$INPUTDATAPbPb"  "$INPUTMCPbPb"  "$TRGPbPb" "$CUTPbPb"   "$SELGENPbPb"   "$ISMCPbPb"   1   "$ISDOWEIGHTPbPb"   "$LABELPbPb"  "$OUTPUTFILEPbPb" "$NPFIT_PbPb" 0 "$CENTPbPbMIN" "$CENTPbPbMAX"
rm fitBs.exe
fi 

echo "-------------------------------------------------------------------------"

if [ $DOANALYSISPbPb_MCSTUDY -eq 1 ]; then      
g++ MCefficiency.C $(root-config --cflags --libs) -g -o MCefficiency.exe 
./MCefficiency.exe 1 "$INPUTMCPbPb"  "$SELGENPbPb" "$SELGENPbPbACCPbPb"  "$RECOONLYPbPb" "$CUTPbPb&&$TRGPbPbMC"  "$LABELPbPb" "$OUTPUTFILEMCSTUDYPbPb" "$ISDOWEIGHTPbPb" "$CENTPbPbMIN" "$CENTPbPbMAX"
rm MCefficiency.exe
fi

echo "-------------------------------------------------------------------------"

if [ $DOANALYSISPbPb_CROSS -eq 1 ]; then      
g++ CrossSectionRatio.C $(root-config --cflags --libs) -g -o CrossSectionRatio.exe 
./CrossSectionRatio.exe "$FONLLOUTPUTFILE"  "$OUTPUTFILEPbPb" "$OUTPUTFILEMCSTUDYPbPb" "$OUTPUTFILEPlotPbPb" 0 "$LABELPbPb" 0 "$LUMIPbPb"
rm CrossSectionRatio.exe
fi

echo "-------------------------------------------------------------------------"

if [ $DORAA -eq 1 ]; then
g++ NuclearModificationFactor.C $(root-config --cflags --libs) -g -o NuclearModificationFactor.exe
./NuclearModificationFactor.exe "$OUTPUTFILEPlotPP" "$OUTPUTFILEPlotPbPb"  "$LABELPbPb" "$OUTPUTFILERAA" "$CENTPbPbMIN" "$CENTPbPbMAX"
rm NuclearModificationFactor.exe
fi
echo "-------------------------------------------------------------------------"

