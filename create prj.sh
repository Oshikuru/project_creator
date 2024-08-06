# debug
# trap 'echo "# $BASH_COMMAND";read' DEBUG

BOLD='\e[1m' 
GREEN='\e[32m'
NORMAL='\e[0m'

printf "${BOLD}"
printf 'Creating folders'

mkdir -p run 		&& printf '.'
mkdir -p src 		&& printf '.'
mkdir -p tb  		&& printf '.'
mkdir -p tcl 		&& printf '.'

printf 'done!\n'

printf 'Add files, then press Enter\n'
read

cd src

#чтобы не писал пустые файлы
shopt -s nullglob
#пишем список файлов в массив
files_vhd=(*.vhd)
files_vhd+=(*/*.vhd)
files_v=(*.v)
files_v+=(*/*.v)
files_sv=(*.sv)
files_sv+=(*/*.sv)

if [ ${#files_vhd[@]} != 0 ]; then
	printf 'List of VHDL files :\n'
	printf "${NORMAL}"
	for ((i = 0; i < ${#files_vhd[@]}; i++))
	do
		echo -e "	"$i". "${files_vhd[$i]}"\n"
	done
	printf "${BOLD}"
fi

if [ ${#files_v[@]} != 0 ]; then
	printf 'List of Verilog files :\n'
	printf "${NORMAL}"
	for ((i = 0; i < ${#files_v[@]}; i++))
	do
		echo -e "	"$i". "${files_v[$i]}"\n"
	done
	printf "${BOLD}"
fi

if [ ${#files_sv[@]} != 0 ]; then
	printf 'List of SystemVerilog files : \n'
	printf "${NORMAL}"
	for ((i = 0; i < ${#files_sv[@]}; i++))
	do
		echo -e "	"$i". "${files_sv[$i]}"\n"
	done
	printf "${BOLD}"
fi


cd ../tb
files_tb=(*.sv)

if [ ${#files_v[@]} != 0 ] || [ ${#files_vhd[@]} != 0 ] || [ ${#files_sv[@]} != 0 ]; then
	if [ ${#files_tb[@]} != 0 ]; then
		printf 'List of TB files : \n'
		printf "${NORMAL}"
		for ((i = 0; i < ${#files_tb[@]}; i++))
		do
			echo -e "	"$i". "${files_tb[$i]}"\n"
		done
		printf "${BOLD}"
		read -p @"Do you need new tb (y/n) : " tb
		if [ "$tb" == "y" ]; then
			read -p @"Enter the name of the project : " name
			rm "$name"Tb.sv 2>/dev/null
			printf '\nCreating Test Bench file'
			echo -e '`timescale 1ns / 1ps'                           >> ""$name"Tb.sv" && printf '.'
			echo -e '`include "sys_param.svh"\n'                     >> ""$name"Tb.sv" && printf '.'
			echo -e "module "$name"Tb #();\n\n"                      >> ""$name"Tb.sv" && printf '.'
			echo -e '	//iClk'                                      >> ""$name"Tb.sv" && printf '.'
			echo -e '	bit clk;'                                    >> ""$name"Tb.sv" && printf '.'
			echo -e '	always #(CLK_PERIOD/2) clk = !clk;\n'        >> ""$name"Tb.sv" && printf '.'
			echo -e '	//iReset'                                    >> ""$name"Tb.sv" && printf '.'
			echo -e '	bit iReset;'                                 >> ""$name"Tb.sv" && printf '.'
			echo -e '	initial begin'                               >> ""$name"Tb.sv" && printf '.'
			echo -e '		iReset = FALSE;'                         >> ""$name"Tb.sv" && printf '.'
			echo -e '		#30ns; iReset = TRUE;'                   >> ""$name"Tb.sv" && printf '.'
			echo -e '	end\n\n\n'                                   >> ""$name"Tb.sv" && printf '.'
			echo -e 'endmodule'                                      >> ""$name"Tb.sv" && printf '.'
			printf 'done\n'
			
		fi
	else
		read -p @"Enter the name of the project : " name
		echo ""$name""
		rm ""$name"Tb.sv" 2>/dev/null
		printf 'Creating Test Bench file'
		echo -e '`timescale 1ns / 1ps'                           >> ""$name"Tb.sv" && printf '.'
		echo -e '`include "sys_param.svh"\n'                     >> ""$name"Tb.sv" && printf '.'
		echo -e "module "$name"Tb #();\n\n"                      >> ""$name"Tb.sv" && printf '.'
		echo -e '	//iClk'                                      >> ""$name"Tb.sv" && printf '.'
		echo -e '	bit clk;'                                    >> ""$name"Tb.sv" && printf '.'
		echo -e '	always #(CLK_PERIOD/2) clk = !clk;\n'        >> ""$name"Tb.sv" && printf '.'
		echo -e '	//iReset'                                    >> ""$name"Tb.sv" && printf '.'
		echo -e '	bit iReset;'                                 >> ""$name"Tb.sv" && printf '.'
		echo -e '	initial begin'                               >> ""$name"Tb.sv" && printf '.'
		echo -e '		iReset = FALSE;'                         >> ""$name"Tb.sv" && printf '.'
		echo -e '		#30ns; iReset = TRUE;'                   >> ""$name"Tb.sv" && printf '.'
		echo -e '	end\n\n\n'                                   >> ""$name"Tb.sv" && printf '.'
		echo -e 'endmodule'                                      >> ""$name"Tb.sv" && printf '.'
		printf 'done\n'	
	fi
else
	echo -e "Theres is NO SOURCE files.."
	read
	exit
fi

if [ ! -f sys_param.svh ]; then
	printf 'Creating parameters header\n'
	read -p @"Enter the freq in Hz : " freq
	echo -e "parameter CLK_FREQ = "$freq";"                  >> "sys_param.svh" && printf '.'
	echo -e "parameter CLK_PERIOD = 1000000000/CLK_FREQ;"    >> "sys_param.svh" && printf '.'
	echo -e "parameter TRUE = 1'b1;"    					 >> "sys_param.svh" && printf '.'
	echo -e "parameter FALSE = 1'b0;"   					 >> "sys_param.svh" && printf '.'
	printf 'done\n'
fi

files_tb=(*.sv)
printf '\nList of TB files :\n' 
printf "${NORMAL}"
for ((i = 0; i < ${#files_tb[@]}; i++))
do
	echo -e "	"$i". "${files_tb[$i]}"\n"
done
printf "${BOLD}"

# генерируем tcl из tb и src
cd ../tcl

read -p @"Do you need new tcl (y/n) : " tcl

if [ $name == "winget" ]; then
	read -p @"Enter the name of new tcl (y/n) : " name
fi

if [ "$tcl" == "y" ]; then
	printf '\nCreating TCL script\n'
	rm "$name.tcl" 2>/dev/null
	read -p @"Coverage? (y/n) : " cover

	echo -e 'quit -sim\n'                                                                                         	>> "$name.tcl" && printf '.'
	echo -e 'cd ../modelsim\n'                                                                                    	>> "$name.tcl" && printf '.'
	echo -e 'transcript on'                                                                                       	>> "$name.tcl" && printf '.'
	echo -e 'vlib work\n'                                                                                         	>> "$name.tcl" && printf '.'
	echo -e '# тестбенч'                                                                                  			>> "$name.tcl" && printf '.'

	if [ $cover == "y" ]; then
		echo -e "vlog -quiet -work work +cover ../tb/"$name"Tb.sv\n"                                                >> "$name.tcl" && printf '.'
	else
		echo -e "vlog -quiet -work work ../tb/"$name"Tb.sv\n"                                                       >> "$name.tcl" && printf '.'
	fi

	echo -e '# исходные файлы'                                                                       				>> "$name.tcl" && printf '.'

		# добавляем vhdl в tcl
		if [ ${#files_vhd[@]} != 0 ]; then
			for ((i = 0; i < ${#files_vhd[@]}; i++))
			do
				if [ $cover == "y" ]; then
					echo -e "vcom -quiet -work work +cover ../src/"${files_vhd[$i]}""                             	>> "$name.tcl" && printf '.'
				else
					echo -e "vcom -quiet -work work ../src/"${files_vhd[$i]}""                                    	>> "$name.tcl" && printf '.'
				fi
			done
			echo -e "\n"                                                                                          	>> "$name.tcl" && printf '.'
		fi
		# добавляем verilog в tcl
		if [ ${#files_v[@]} != 0 ];	then
			for ((i = 0; i < ${#files_v[@]}; i++))
			do
				if [ $cover == "y" ]; then
					echo -e "vlog -quiet -work work +cover ../src/"${files_v[$i]}""                               	>> "$name.tcl" && printf '.'
				else
					echo -e "vlog -quiet -work work ../src/"${files_v[$i]}""                                      	>> "$name.tcl" && printf '.'
				fi
			done
			echo -e "\n"                                                                                          	>> "$name.tcl" && printf '.'
		fi
		# добавляем sv в tcl
		if [ ${#files_sv[@]} != 0 ]; then
			for ((i = 0; i < ${#files_sv[@]}; i++))
			do
				if [ $cover == "y" ]; then
					echo -e "vlog -quiet -work work +cover ../src/"${files_sv[$i]}""                              	>> "$name.tcl" && printf '.'
				else
					echo -e "vlog -quiet -work work ../src/"${files_sv[$i]}""                                     	>> "$name.tcl" && printf '.'
				fi
			done
			echo -e "\n"                                                                                          	>> "$name.tcl" && printf '.'
		fi

		if [ $cover == "y" ]; then
			echo -e "vsim -t 1ps -voptargs=+acc -quiet -wlfdeleteonquit -coverage +notimingchecks work."$name"Tb\n" >> "$name.tcl" && printf '.'
		else
			echo -e "vsim -t 1ps -voptargs=+acc -quiet -wlfdeleteonquit +notimingchecks work."$name"Tb\n"           >> "$name.tcl" && printf '.'
		fi

	echo -e "add wave -divider -height 30 "$name"Tb"                                                                >> "$name.tcl" && printf '.'
	echo -e "add wave -color #33CF78 -radix decimal 		-radixshowbase 0 -group "$name"Tb /*\n\n"               >> "$name.tcl" && printf '.'
	echo -e "configure wave -signalnamewidth 1 -namecolwidth 200 -valuecolwidth 100 -timelineunits ns"            	>> "$name.tcl" && printf '.'
	echo -e "run 500 us"                                                                                          	>> "$name.tcl" && printf '.'
	echo -e "wave zoom full"    																					>> "$name.tcl" && printf '.'
	printf 'done\n'
fi


files_tcl=(*.tcl)

if [ ${#files_tcl[@]} != 0 ]; then
	printf '\nList of TCL files : \n'
	printf "${NORMAL}"
	for ((i = 0; i < ${#files_tcl[@]}; i++))
	do
		echo -e "	"$i". "${files_tcl[$i]}"\n"
	done
	printf "${BOLD}"
	cd ../run
	rm "runTCL.sh" 2>/dev/null
	printf 'Creating bash script'
	echo -e "#debug"                                                    >> "runTCL.sh" && printf '.'
	echo -e "#trap 'echo "# '$BASH_COMMAND'";read' DEBUG\n"             >> "runTCL.sh" && printf '.'
	echo -e "taskkill //f //im vsimk.exe 2>/dev/null"          			>> "runTCL.sh" && printf '.'
	echo -e "taskkill //f //im vish.exe 2>/dev/null\n"                  >> "runTCL.sh" && printf '.'
	echo -e "cd .."                                                     >> "runTCL.sh" && printf '.'
	echo -e "rm -rf modelsim 2>/dev/null"                               >> "runTCL.sh" && printf '.'
	echo -e "mkdir -p modelsim"                                         >> "runTCL.sh" && printf '.'
	echo -e "cd modelsim\n"                                             >> "runTCL.sh" && printf '.'
	echo -e "rm vsim.wlf 2>/dev/null\n"                                 >> "runTCL.sh" && printf '.'
	
	echo -e "echo Choose tcl script to run:"                            >> "runTCL.sh" && printf '.'
	for ((i = 0; i < ${#files_tcl[@]}; i++))
	do
		echo "echo "$i". "${files_tcl[$i]}""                            >> "runTCL.sh" && printf '.'
	done
	echo -e "echo q. Quit.\n"                                           >> "runTCL.sh" && printf '.'
	
	echo -e 'read -p @"Enter the number of the script : " nmb\n'        >> "runTCL.sh" && printf '.'

	for ((i = 0; i < ${#files_tcl[@]}; i++))
	do
		if [ $i == 0 ]; then
			echo 'if [ $nmb == '$i' ]; then'                      		>> "runTCL.sh" && printf '.'
			echo "	questasim -do ../tcl/"${files_tcl[$i]}"; exit" 		>> "runTCL.sh" && printf '.'
		else
			echo 'elif [ $nmb == '$i' ]; then'                       	>> "runTCL.sh" && printf '.'
			echo "	questasim -do ../tcl/"${files_tcl[$i]}"; exit" 		>> "runTCL.sh" && printf '.'
		fi
	done

	echo -e 'elif [ $nmb == "q" ]; then'                                >> "runTCL.sh" && printf '.'
	echo -e '	exit'                                                   >> "runTCL.sh" && printf '.'
	echo -e 'else'                                                      >> "runTCL.sh" && printf '.'
	echo -e '	exit'                                                   >> "runTCL.sh" && printf '.'
	echo -e 'fi'                                                        >> "runTCL.sh" && printf '.'
	printf 'done\n'
else
	printf 'Theres is NO TCL files..\n'
fi


printf '\nPress Enter to quit..'
read