# sh refactor_Cerevisiae_BAM.sh input.bam out_name

if [ $# != 2 ] ; then
	echo "Need 2 Command Arguments:"
	echo "sh refactor_Cerevisiae_BAM.sh input.bam out_name"
      exit 0
fi

echo "Converting to SAM"
samtools view -h -o out.sam $1
echo "Conversion Complete"

echo "Stream Editing..."
#stream edit the chromosome names
sed -e 's/chr01/chrI/g' -e 's/chr02/chrII/g' -e 's/chr03/chrIII/g' -e 's/chr04/chrIV/g' -e 's/chr05/chrV/g' -e 's/chr06/chrVI/g' -e 's/chr07/chrVII/g' -e 's/chr08/chrVIII/g' -e 's/chr09/chrIX/g' -e 's/chr10/chrX/g' -e 's/chr11/chrXI/g' -e 's/chr12/chrXII/g' -e 's/chr13/chrXIII/g' -e 's/chr14/chrXIV/g' -e 's/chr15/chrXV/g'  -e 's/chr16/chrXVI/g' out.sam > new.sam
echo "Stream Edit Complete"

echo "Converting to BAM"
#transform back to bam
samtools view -S -b new.sam -o $2.temp.bam
echo "BAM Conversion Complete"

echo "Sorting BAM..."
samtools sort $2.temp.bam $2.bam
echo "Sort Complete"

echo "Indexing BAM..."
samtools index $2.bam $2.bam.bai
echo "Refactor Complete"

echo "Cleaning temporary files..."
rm out.sam
rm new.sam
rm $2.temp.bam
echo "Program Complete"
