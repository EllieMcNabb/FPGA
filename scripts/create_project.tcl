# ============================================================
# Vivado Project Creation Script (SystemVerilog, Git-friendly)
# ============================================================

# -------- USER SETTINGS --------
set PROJECT_NAME FPGA
set PROJECT_DIR  ./vivado
set PART         xc7a100tcsg324-1
set TOP_MODULE   top
# --------------------------------

# -------------------------------
# Determine script location (robust path handling)
# -------------------------------
set SCRIPT_DIR [file dirname [info script]]

puts "==> Creating project: $PROJECT_NAME"
puts "Script directory: $SCRIPT_DIR"

# Clean project create
create_project $PROJECT_NAME $PROJECT_DIR -part $PART -force

# Set project language (Verilog required; SV files handled automatically)
set_property target_language Verilog [current_project]

# -------------------------------
# Add RTL sources (.sv/.v/.svh)
# -------------------------------
set rtl_files [glob -nocomplain \
$SCRIPT_DIR/../rtl/*.sv \
$SCRIPT_DIR/../rtl/*.v \
$SCRIPT_DIR/../rtl/*.svh]

if {[llength $rtl_files] > 0} {
    add_files $rtl_files
    puts "Added RTL sources:"
    foreach f $rtl_files { puts "  $f" }
} else {
    puts "WARNING: No RTL sources found!"
}

# Force SystemVerilog only if files exist
set sv_files [get_files *.sv]
if {[llength $sv_files] > 0} {
    set_property file_type SystemVerilog $sv_files
}

set svh_files [get_files *.svh]
if {[llength $svh_files] > 0} {
    set_property file_type SystemVerilog $svh_files
}

# -------------------------------
# Add constraints (.xdc)
# -------------------------------
set xdc_files [glob -nocomplain $SCRIPT_DIR/../constraints/*.xdc]
if {[llength $xdc_files] > 0} {
    add_files -fileset constrs_1 $xdc_files
    puts "Added constraints:"
    foreach f $xdc_files { puts "  $f" }
} else {
    puts "WARNING: No constraints found!"
}

# -------------------------------
# Add IP (.xci)
# -------------------------------
set ip_files [glob -nocomplain $SCRIPT_DIR/../ip/*.xci]
if {[llength $ip_files] > 0} {
    add_files $ip_files
    puts "Added IP:"
    foreach f $ip_files { puts "  $f" }
} else {
    puts "No IP found."
}

# -------------------------------
# Set top module
# -------------------------------
set_property top $TOP_MODULE [current_fileset]

# Update compile order
update_compile_order -fileset sources_1

# -------------------------------
# Generate IP output products (if any)
# -------------------------------
if {[llength [get_ips -quiet]] > 0} {
    generate_target all [get_ips]
    puts "Generated IP output products"
}

# -------------------------------
# Optional: Launch synthesis / implementation (commented)
# -------------------------------
# launch_runs synth_1
# wait_on_run synth_1
#
# launch_runs impl_1 -to_step write_bitstream
# wait_on_run impl_1

puts "==> Project creation complete"
puts "Open project at: $PROJECT_DIR/$PROJECT_NAME.xpr"
