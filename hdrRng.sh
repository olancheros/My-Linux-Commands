#!/bin/tcsh -f

clear

#------------------------------------------------------------------------------#
#              Author:   Oscar Lancheros                                       #
#              Software: PROMAX - SeisSpace                                    #
#              Date:     May 2023                                              #
#------------------------------------------------------------------------------#

#* The aim of this script is to get the necessary info to update the Excel files used
#* in the generation of the STATUS FILE and the PROCESSED LINES FILE for the final products
#* SEG-Y generation. This information is obtained from the PROMAX's tool TRACE HEADER RANGE
#* log file applied to the Geometry Shot Gathers.

#* For 2D lines, it's necessary to include a TRACE_HEADER_MATH tool into the Promax flow
#* to generate the word ILINE_NO, which will identify the line's name. Then, that number
#* will be updated with the line's name in this script using the SED command. So, be aware
#* of updating line 2 (SED command) of this script in the foreach loop with the right line's
#* prefix.

#* The script will ask the user to input the path for the log files.
#! It's important to keep in mind that the input folder must contain just the log files,
#! otherwise, the script will fail or will generate a wrong output file.


echo
echo "                                                                         "
echo "   ____________________________________________________________          "
echo "  *                                                            *"
echo "  *                                                            *"
echo "  *     Script to get the main information of a 2D Project     *"
echo "  *    using Promax's Header Value Range tool over a dataset   *"
echo "  *   of shot-gathers with geometry applied for each 2D line.  *"
echo "  *                                                            *"
echo "  *   Input: folder path of Log Files <<HEADER VALUES RANGE>>  *"
echo "  *                                                            *"
echo "  *____________________________________________________________*"
echo ""
echo ""
echo -n     " \e[1;91mInput the folder path that contains the log files: \e[0m"
set folderName = $<
echo ""

#---------------------TRACE HEADER SUMMARY ANALYSIS----------------------------#

cd $folderName

echo "Script has started..."
echo ""

foreach fileName (*)

    grep -a "ILINE_NO  3" $fileName | awk '{print $1}' > $fileName.tmpil
    sed -i s/21/SSJN1-2021-/g $fileName.tmpil
    grep -a "SOU_SLOC  E" $fileName | awk '{print $1, $2}' > $fileName.tmpsou
    grep -a "SRF_SLOC  E" $fileName | awk '{print $1, $2}' > $fileName.tmprec
    grep -a "SIN       S" $fileName | awk '{print $2}' > $fileName.tmpsin
    grep -a "CDP       C" $fileName | awk '{print $1, $2}' > $fileName.tmpcdp
    grep -a "CDP_NFLD  N" $fileName | awk '{print $2}' > $fileName.tmpfold
    grep -a "THDRMATH                   0.0" $fileName | awk '{print $3}' > $fileName.tmpsi
    grep -a "THDRMATH                   0.0" $fileName | awk '{print $4/1000}' > $fileName.tmprl
    grep -a "CHAN      R" $fileName | awk '{print $2}' > $fileName.tmpchan
    grep -a "REC_ELEV  R" $fileName | awk '{print $2/1}' > $fileName.tmpelev

    paste $fileName.tmpil $fileName.tmpsou $fileName.tmprec $fileName.tmpsin $fileName.tmpcdp $fileName.tmpfold $fileName.tmpsi $fileName.tmprl $fileName.tmpchan $fileName.tmpelev > $fileName.tmpol1

    awk 'NR == 1 {printf"%-15s%-8s%-8s%-10s%-10s%-9s%-9s%-9s%-6s%-10s%-11s%-10s%s\n","LINE","FST_SP","LST_SP","FST_RCVR","LST_RCVR","TOT_SPS","FST_CDP","LST_CDP","FOLD","SAMP_INT", "REC_LNGTH","TOT_CHAN","ELEV"};\
        {printf"%-15s%-8s%-8s%-10s%-10s%-9s%-9s%-9s%-6s%-10s%-11s%-10s%s\n",$1,$2+.5,$3+.5,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13}' $fileName.tmpol1 > $fileName.qcHdrRng.txt

    rm $fileName.tmp*
end

cat *qcH* | sort -n -k1 | uniq > outputfile.prn

rm *qcH*

echo "Done! Look for the output prn file at $folderName"
echo ""

# END of SCRIPT
#! With Love Oscar Lancheros ;)