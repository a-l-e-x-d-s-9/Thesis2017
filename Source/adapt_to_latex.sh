#!/usr/bin/env python
# -*- coding: UTF-8 -*-
import sys
import fileinput
import os
import re

def get_args():
    if len( sys.argv ) != 5:
        raise IOError("Must get: 1. source file, 2. main tex. 3. abstract tex. 4. abstract tex")
        
    file_source_path            = sys.argv[1]
    print( "file_source_path     : " + file_source_path )
    
    file_main_tex_path          = sys.argv[2]
    print( "file_main_tex_path: " + file_main_tex_path )
    
    file_abstract_tex_path      = sys.argv[3]
    print( "file_abstract_tex_path: " + file_abstract_tex_path )
    
    file_appendices_tex_path    = sys.argv[4]
    print( "file_appendices_tex_path: " + file_appendices_tex_path )


    if os.path.exists(file_source_path):
        print( "source file: " + file_source_path )
        file_source = open( file_source_path, 'r' )
    else:
        raise ImportError( "source file does not exists: " + file_source_path )
    
    if os.path.exists(file_abstract_tex_path):
        print( "abstract tex file: " + file_abstract_tex_path )
        file_abstract_tex = open( file_abstract_tex_path, 'r' )
    else:
        raise ImportError( "abstract file does not exists: " + file_abstract_tex_path )
    
    file_main_tex = open( file_main_tex_path, 'w' )
    
    file_appendices_tex = open( file_appendices_tex_path, 'w' )

    return file_source, file_main_tex, file_abstract_tex, file_abstract_tex_path, file_appendices_tex


def latex_add_label( in_text, label ):
    return "\\\\" + label + "{" + in_text + "}" 

def latex_italic( in_text ):
    return latex_add_label( in_text, "textit" )
    
def latex_italic_middle( in_text ):
    return r"\1" + latex_add_label( r"\2", "textit" ) + r"\3"
     
def latex_add_subscript( in_text ):
    return latex_add_label( in_text, "textsubscript" )
    
def latex_add_supscript( in_text ):
    return latex_add_label( in_text, "textsuperscript" )
    
def latex_subscript( in_text ):
    return r"\1" + r"\2" + latex_add_subscript( r"\3" )
    
def latex_supscript( in_text ):
    return r"\1" + r"\2" + latex_add_supscript( r"\3" ) + r"\4"
    
def latex_color_for_uppaal_function( in_text ):
    return latex_add_label( in_text,"textcolor{ColorUppaalFunction}" )
    
def latex_color_for_uppaal_code_middle( in_text ):
    return r"\1" + latex_add_label( latex_italic(r"\2"),"textcolor{ColorUppaalCode}" ) + r"\3"

def latex_color_for_uppaal_middle( (pattern_to_color, color) ):
    return r"\1" + latex_add_label( latex_italic(r"\2"),"textcolor{" + color + "}" ) + r"\3"

def latex_color_for_uppaal_channel( in_text ):
    return latex_add_label( in_text,"textcolor{ColorUppaalChannel}" )
    
def latex_pta_state_name( in_text ):
    return latex_italic(latex_add_label( in_text,"textcolor{ColorUppaalState}" )) + r"\2"
    
def latex_citation( in_text ):
    return r"\1" + latex_add_label( r"\2", "cite" )


def latex_bullets( in_text ):
    return "\n\\item"
    
def latex_new_page( in_text ):
    return "\n\\clearpage\r"
    
def latex_color_change( in_text ):
    return latex_add_label( in_text,"textcolor{purple(munsell)}" )
    
def latex_color_todo( in_text ):
    return latex_add_label( in_text,"textcolor{red}" )

def latex_color_get_change_color():
    return "chartreuse(web)"

def latex_color_change_start( in_text ):
    #return "\\\\" + "sethlcolor{" + latex_color_get_change_color() + "}" + " \\\\hl{" + in_text 
    return "\\\\" + "color{purple(munsell)}" + in_text 
    
def latex_color_change_end( in_text ):
    #return in_text + "}" 
    return in_text  + "\\\\" + "color{black}" 

def latex_add_href( (original_text, url_to_use) ):
    print( "*** latex_add_href")
    print( "    original_text:", original_text )
    print( "    url_to_use   :", url_to_use    )
    return "\\\\href{" + url_to_use + "}{\setulcolor{blue}\ul{" + original_text + "}}"

def latex_simple_replace( (original_text, replace_with_text) ):
    print( "*** latex_simple_replace")
    print( "    original_text      :", original_text )
    print( "    replace_with_text  :", replace_with_text    )
    return replace_with_text

def latex_escape_characters( in_text ):
    #in_text = in_text.replace( "[change]", "\\[change\\]" )
    in_text = in_text.replace( "\Act1"                          , "\\textbackslash{}Act1"                       )
    in_text = in_text.replace( "\Act2"                          , "\\textbackslash{}Act2"                       )
    in_text = in_text.replace( "[plp-folder-path]"              , "\\small[plp-folder-path\\small]"             )
    in_text = in_text.replace( "[control-graph-file]"           , "\\small[control-graph-file\\small]"          )
    in_text = in_text.replace( "[generate-uppaal-system-file]"  , "\\small[generate-uppaal-system-file\\small]" )
    in_text = in_text.replace( "[configuration-file]"           , "\\small[plp-folder-path\\small]"             )
    in_text = in_text.replace( "[MIN_TIME, MAX_TIME]"           , "\\small[MIN_TIME, MAX_TIME\\small]"          )
    in_text = in_text.replace( "[MIN, MAX]"                     , "\\small[MIN, MAX\\small]"                    )
    in_text = in_text.replace( "[0,1]"                          , "\\small[0,1\\small]"                         )
    in_text = in_text.replace( "[change]"                       , "\\small[change\\small]"                      )
    in_text = in_text.replace( "[change-]"                      , "\\small[change-\\small]"                     )
    in_text = in_text.replace( "[-change]"                      , "\\small[-change\\small]"                     )
    in_text = in_text.replace( "[1:plp-folder-path]"            , "\\small[1:plp-folder-path\\small]"           )
    in_text = in_text.replace( "[2:control-graph-file]"         , "\\small[2:control-graph-file\\small]"        )
    in_text = in_text.replace( "[3:generate-uppaal-system-file]", "\\small[3:generate-uppaal-system-file\\small]")
    in_text = in_text.replace( "[4:configuration-file]"         , "\\small[4:configuration-file\\small]"        )

    in_text = in_text.replace( "&&"                             , "\\&\\&"                                      )
    in_text = in_text.replace( "S_([123])"                      , "S\_\1"                                       )
    in_text = in_text.replace( "([ab])_chan"                    , "\1\_chan"                                    )
    

    in_text = in_text.replace( "→"                              , "$\\rightarrow$"                              )
    in_text = in_text.replace( "←"                              , "$\\leftarrow$"                               )
    in_text = in_text.replace( "𝜺"                              , "$\\varepsilon$"                              )
    in_text = in_text.replace( "∀"                              , "$\\forall$"                                  )
    in_text = in_text.replace( "∃"                              , "$\\exists$"                                  )
    in_text = in_text.replace( "∊"                              , "$\\in$"                                      )
    in_text = in_text.replace( "∈"                              , "$\\in$"                                      )
    in_text = in_text.replace( "||"                             , "$\|$"                                        )
    in_text = in_text.replace( " | "                            , " $\\vert$ "                                  )

                        
    return in_text

def add_styles( in_text, style_array ):
    for patterns_array, style_functions_array  in style_array:
        for pattern in patterns_array:
            for style_function in style_functions_array:
                print( "pattern: ", pattern, ", style_function: ", style_function )
                if ( isinstance(pattern, list) ):
                    in_text = re.sub( pattern[0], style_function( pattern ), in_text )
                else:
                    in_text = re.sub( pattern, style_function( r"\1" ), in_text )
                

    return in_text

style_array = [
    [ [ r'([Pp]erformance [Ll]evel [Pp]rofiles)', 
        r'([Cc]ontrol [Gg]raph[s]?)',
        r'([Pp]robabilistic [Tt]imed [Aa]utomaton[s]?)',
        r'([Ss]equential [Nn]ode[s]?)', 
        r'([Pp]robabilistic [Nn]ode[s]?)', 
        r'([Cc]onditional [Nn]ode[s]?)', 
        r'([Cc]oncurrent [Nn]ode[s]?)',
        r'([Cc]oncurrent [Mm]emory)', 
        r'(Procedural Reasoning System)',
        r'(Task Description Language)',
        r'(Reactive Model-based Programming Language)',
        r'(RMPLVerifier)',
        r'(Behavior Interaction Priority)',
        r'(The Generator of Modules)',
        r'([Ii]nteger[s]?)',
        r'([Cc]lock[s]?)',
        r'([Gg]oal condition[s]?)',
        r'( scheduler )',
        #r'([Gg]uard[s]?)',
        r'(Claim[:])',
        r'(Proof[:])',
        r'([Pp]robabilistic transition function)',
        r'([Ii]nvariant condition)',
        r'([Cc]oncurrent module positive)',
        r'([Cc]oncurrent module negative)',
        r'([Cc]oncurrent condition hold)',
        r'([Cc]oncurrent condition check)',
        r'([Cc]oncurrent memory module[s]?)',
        r'([Ss]ynchronization signal[s]?)',
        r'([Pp]robabilistic transition function)',
        r'([Ii]nvariant condition[s]?)',
        r'([Ee]nabling condition[s]?)',
        r'(codegen\.common\.CodeGenerator)',
        r'(parallel composition)',
        r'([Cc]lock [s]?)',
        r'([Cc]lock constraint[s]?)',
        r'([Vv]ariable constraint[s]?)',
        r'(resource_currentr)',
        r'(resource_neededr)',
        r'([Gg]oal condition[s]?)',
        r'([Gg]oal condition update)',
        r'([Oo]bserved variable update)',
        r'([Ss]ide effects update)',
        r'([Rr]equired resource check)',
        r'([Tt]ermination condition[s]?)',
        r'([Oo]bserved variable[s]?)',
        r'([Uu]rgent)',
        r'([Cc]oncurrent condition[s]?)',
        r'([Ee]xecution frequency)',
        
        r'(Observe PLP)',
        r'(Achieve PLP)',
        r'(Maintain PLP)',
        r'(Detect PLP)',
        r'((?:PTA)?(?:s)?PLP Observe)',
        r'((?:PTA)?(?:s)?PLP Achieve)',
        r'((?:PTA)?(?:s)?PLP Maintain)',
        r'((?:PTA)?(?:s)?PLP Detect)',
        
        r'([Cc]oncurrent module)',
        r'([Rr]eachability graph)',
        r'([Tt]ask[s]? graph[s]?)',
        
        ], [latex_italic] ],
    [ [ r'()([Gg]uard)( attribute[s]?)',
        r'()([Uu]date)( attribute[s]?)',
        r'()([Ii]nvariant)( attribute[s]?)',
        r'()([Ss]ynchronization)( attribute[s]?)',
        r'()([Pp]robability)( attribute[s]?)',
        r'(attribute[s]? )([“][^ ]+[”])()',
        r'([Ee]dge’s )([^ ]+)()',
        r'([Nn]ode’s )([^ ]+)()',
        r'()([Rr]eals)()',
        r'()([Rr]eal[s]?)( number)',
        r'()([Rr]eal[s]?)( variable)',
        r'()([Rr]eal[s]?)( value)',

        ], [latex_italic_middle] ],
    [ [ r'(PTA)([s]?)(PLP)',
        r'(PTA)()([ABC])',
        r'(PTA)()(Node)',
        r'(id)()([12])',
        r'(C)()([12])',
        r'(Value)()([12])',
        r'(resource_current)()(r)',
        r'(resource_needed)()(r)',
        ], [latex_subscript] ],
    [ [ r'(G)()(en)(oM)' ], [latex_supscript] ],
    [ [ [ r'()(is_process_would_like_to_access(?:\[[^\]]*\])?(?: == true)?(?: == false)?)()'    , "ColorEdgeGuard" ], 
        [ r'()(condition\[[1k]\] == true)()'                                                    , "ColorEdgeGuard" ], 
        [ r'()(robot_location == at_b_target)()'                                                , "ColorEdgeGuard" ], 
        [ r'()(process_access_granted_id)()'                                                    , "ColorEdgeGuard" ], 
        [ r'()(concurrent_info.concurrent_data\[[^\]]*\].value)()'                              , "ColorEdgeGuard" ], 
        [ r'()(result(?:[_][12])? == (?:true|false))()'                                         , "ColorEdgeGuard" ], 
        [ r'()(successor_can_run(?:\[[^\]]*\])?)()'                                             , "ColorEdgeGuard" ], 
        [ r'()(variable_id)()'                                                                  , "ColorEdgeGuard" ], 
        [ r'()(preconditions)( guard)'                                                          , "ColorEdgeGuard" ], 
        [ r'()(local_time ∈ run_distribution_success\(\))()'                                    , "ColorEdgeGuard" ], 
        [ r'()(local_time ∈ run_distribution_failure[^\(]*\(\))()'                              , "ColorEdgeGuard" ], 
        [ r'()(result)( variable)'                                                              , "ColorEdgeGuard" ], 
        [ r'()(result_1)( and result_2 variable)'                                               , "ColorEdgeGuard" ], 
        [ r'()(result_2)( variable)'                                                            , "ColorEdgeGuard" ], 
        [ r'()(termination_success)()'                                                          , "ColorEdgeGuard" ], 
        [ r'()(termination_failure)()'                                                          , "ColorEdgeGuard" ], 
        [ r'()(robot_location)()'                                                               , "ColorEdgeGuard" ], 
        [ r'()(at_b_target)()'                                                                  , "ColorEdgeGuard" ], 
        [ r'()(repeat_terminate)()'                                                             , "ColorEdgeGuard" ], 
        
         
        [ r'()(concurrent_notify(?:\[[^\]]*\])?[\?!]?)()'                                       , "ColorUppaalChannel" ], 
        [ r'()(concurrent_job(?:\[[^\]]*\])?[\?!]?)()'                                          , "ColorUppaalChannel" ],
        [ r'()(concurrent_lock_process(?:\[[^\]]*\])?[\?!]?)()'                                 , "ColorUppaalChannel" ],         
        [ r'()(concurrent_lock_release(?:\[[^\]]*\])?[\?!]?)()'                                 , "ColorUppaalChannel" ],         
        [ r'()(sync_channel[\?!]?)()'                                                           , "ColorUppaalChannel" ],
        [ r'()(try_to_run_successor(?:\[[^\]]*\])?[\?!]?)()'                                    , "ColorUppaalChannel" ],      
        [ r'()(try_to_run[\?!]? )()'                                                            , "ColorUppaalChannel" ],
        [ r'()(scheduler_release[\?!]?)()'                                                      , "ColorUppaalChannel" ],
        [ r'()(pta_start(?:\[[^\]]*\])?[\?!]?)()'                                               , "ColorUppaalChannel" ],
        [ r'()(pta_done(?:\[[^\]]*\])?[\?!]?)()'                                                , "ColorUppaalChannel" ],
        [ r'()(can_start(?:\[[^\]]*\])?[\?!]?)()'                                               , "ColorUppaalChannel" ],
        [ r'()(run_scheduler(?:\[[^\]]*\])?[\?!]?)()'                                           , "ColorUppaalChannel" ],
        [ r'()(concurrent_lock_relese(?:\[[^\]]*\])?[\?!]?)()'                                  , "ColorUppaalChannel" ],
        [ r'()([ab]_chan(?:\[[^\]]*\])?[\?!]?)()'                                               , "ColorUppaalChannel" ],
        
        [ r'()(wait_job)()'                                                                     , "ColorUppaalState" ],
        [ r'()(time_pass)()'                                                                    , "ColorUppaalState" ],
        [ r'()(init_node)()'                                                                    , "ColorUppaalState" ],
        [ r'()(repeat_wait)()'                                                                  , "ColorUppaalState" ],
        [ r'()(wait_maintain_true)()'                                                           , "ColorUppaalState" ],
        [ r'()(main_success)()'                                                                 , "ColorUppaalState" ],
        [ r'()(main_done)()'                                                                    , "ColorUppaalState" ],
        [ r'()(check_termination)()'                                                            , "ColorUppaalState" ],
        [ r'()(main_failure_[12m])()'                                                           , "ColorUppaalState" ],
        [ r'()(main_failure)([^_])'                                                             , "ColorUppaalState" ],
        [ r'()(failure_termination)()'                                                          , "ColorUppaalState" ],
        [ r'()(init_state)()'                                                                   , "ColorUppaalState" ],
        [ r'([^_])(failure_[1m])()'                                                             , "ColorUppaalState" ],
        
        
        [ r'()(preliminary_memory_access)()'                                                    , "ColorUppaalState" ],
        [ r'()(concluding_memory_access)()'                                                     , "ColorUppaalState" ],
        
        
        [ r'()(success)( and end state)'                                                        , "ColorUppaalState" ],      
        [ r'()(main_success)( and access_memory_last state)'                                    , "ColorUppaalState" ],      
        [ r'()(start)( to synced state)'                                                        , "ColorUppaalState" ],      
        [ r'()(end)( to start state)'                                                           , "ColorUppaalState" ],   
        [ r'()(end)( and synced state)'                                                         , "ColorUppaalState" ],     
        [ r'()(selected)( and released state)'                                                  , "ColorUppaalState" ],            
        [ r'()(synced)( state)'                                                                 , "ColorUppaalState" ],
        [ r'()(start)( state)'                                                                  , "ColorUppaalState" ],
        [ r'()(success)( state)'                                                                , "ColorUppaalState" ],
        [ r'()(choose)( state)'                                                                 , "ColorUppaalState" ],
        [ r'()(end)( state)'                                                                    , "ColorUppaalState" ],
        [ r'()(done)( state)'                                                                   , "ColorUppaalState" ],
        [ r'(state )(done)()'                                                                   , "ColorUppaalState" ],
        [ r'()(wait)( state)'                                                                   , "ColorUppaalState" ],
        [ r'()(choose)( to selected)'                                                           , "ColorUppaalState" ],
        [ r'()(choose)( and selected)'                                                          , "ColorUppaalState" ],
        [ r'()(selected)( and waiting)'                                                         , "ColorUppaalState" ],
        [ r'()(choose)( to released)'                                                           , "ColorUppaalState" ],
        [ r'()(S_[123])()'                                                                      , "ColorUppaalState" ],
        [ r'()(selected)( state)'                                                               , "ColorUppaalState" ],
        [ r'()(waiting)( state)'                                                                , "ColorUppaalState" ],
        [ r'()(released)( state)'                                                               , "ColorUppaalState" ],
        
        [ r'()(concurrent_read(?:\([^\)]*\))?)()'                                               , "ColorUppaalFunction" ],        
        [ r'()(concurrent_write(?:\([^\)]*\))?)()'                                              , "ColorUppaalFunction" ],         
        [ r'()(concurrent_request_add(?:\([^\)]*\))?)()'                                        , "ColorUppaalFunction" ],               
        [ r'()(concurrent_request_remove_request(?:\([^\)]*\))?)()'                             , "ColorUppaalFunction" ],                         
        [ r'()(concurrent_signal_access(?:\([^\)]*\))?)()'                                      , "ColorUppaalFunction" ],                
        [ r'()(initialize_variables(?:\([^\)]*\))?)()'                                          , "ColorUppaalFunction" ], 
        
        [ r'()(goal_assignment_[0k] = C_[0k])()'                                                , "ColorEdgeUpdate" ],            
        [ r'()(goal_assignment_i)()'                                                            , "ColorEdgeUpdate" ],            
        [ r'()(C_i)()'                                                                          , "ColorEdgeUpdate" ],           
        [ r'()(concurrent_info)([ ])'                                                           , "ColorEdgeUpdate" ],           
        
        
        [ r'()(probability_success)()'                                                          , "ColorEdgeProbability" ],
        [ r'()(probability_failure_[12m])()'                                                    , "ColorEdgeProbability" ], 
        [ r'()(probability_failure)([^_])'                                                      , "ColorEdgeProbability" ], 
        
        ], [latex_color_for_uppaal_middle] ],
    [ [ r'([\] ])\[(\d+)\]'], [latex_citation] ],
    [ [ r'\n[ \t]*(\*)'], [latex_bullets] ],
    [ [ r'(\[change\])'], [latex_color_change] ],
    [ [ r'(\[TODO\][^\r\n\.\{\}\\]*)'],     [latex_color_todo] ],
    [ [ r'(\[change-\])'], [latex_color_change_start] ],
    [ [ r'(\[-change\])'], [latex_color_change_end] ],
    [ [ r'(\n________________\r)'], [latex_new_page] ],
    [ [ 
        [ 'https://github.com/a-l-e-x-d-s-9/plps_verification.git', 'https://github.com/a-l-e-x-d-s-9/plps_verification.git' ],
        [ 'IntelliJ IDEA', 'https://www.jetbrains.com/idea/download' ],
        [ 'UPPAAL 4.1.20-stratego-4', 'http://people.cs.aau.dk/~marius/stratego/download.html#download' ],
        [ 'Ubuntu 17.04', 'http://releases.ubuntu.com/17.04/' ],
    ], [latex_add_href] ],
     [ [ 
        [ 'c_l_o_c_k', 'clock' ],
        [ 'd_o_u_b_l_e', 'double' ],
    ], [latex_simple_replace] ],
]

# TODO: Add "Claim:" and "Proof:" to italic + new line.

# Eventually the folowing may be deleted:
#   scheduler_wait
#   scheduler_release

def print_all_states( in_text ):
    pattern_state   = re.compile(r'((?:or |and )?[^ ]* state)')
    all_states      = re.findall( pattern_state, in_text )

    for state in all_states:
        print(state)

#citation_convert_numbers_to

def make_link( in_text ):
    in_text = in_text.replace( ".", "_" )
    in_text = in_text.replace( " ", "_" )
    return in_text

def process_attachment( attachment ):
    attachment_command, attachment_data = attachment
    print( "attachment_command  :" + attachment_command )
    print( "attachment_data     :" + attachment_data )
    
    attachment_command_match = re.search( r"([^,]+),([^,]+)", attachment_command )

    command_type    = attachment_command_match.group(1)
    command_source  = attachment_command_match.group(2)
    
    print( "command_type        :" + command_type   )
    print( "command_source      :" + command_source )
    
    if ( "image" == command_type ):
        pass
    


def main():
    reload(sys)
    sys.setdefaultencoding('utf-8')
    
    file_source, file_main_tex, file_abstract_tex, file_abstract_tex_path, file_appendices_tex = get_args()
    
    #file_main_tex.write("Good: " + file_source.readline() )
    
    file_source_text = file_source.read()
    file_source.close()
    
    delimeter_references    = "References\r"
    delimiter_appendix      = "________________\r"
    source_before_references, source_after_references   = file_source_text.split(delimeter_references)
    source_references, source_appendix                  = source_after_references.split(delimiter_appendix)
    
    appendices_text = ( "\\appendix\n"
                        "\\clearpage\n"
                        "\\phantomsection\n"
                        "\\addcontentsline{toc}{chapter}{Appendix}\n"
                        "\\renewcommand{\\thechapter}{A\\arabic{chapter}}\n"
                        "%%\\chapter{Appendix}\n"
                        "%%\\chapter{Appendix}\n"
                        "%%\\chapter{Appendix}\n"
                        "%%\\section*{Appendices}\n"
                        "%%\\addcontentsline{toc}{section}{Appendices}\n"
                        "%%\\renewcommand{\\thesubsection}{\\Alph{subsection}}\n\n" )
    
    # Remove all the TODOs and change markers
    source_before_references = source_before_references.replace( "[change-]" , "" )
    source_before_references = source_before_references.replace( "[-change]" , "" )
    source_before_references = re.sub( r"\[TODO\][^\r\n]+", "", source_before_references )

    source_before_references = add_styles( source_before_references, style_array )
    #print( re.sub( r'(concurrent_job(?:\[[^\]]*\])?[\?!]?)', r"--\1--", "abcdesfkdjelkfjdslk concurrent_job[sdas] concurrent_job concurrent_job? concurrent_job[32]! wwrqwfrsgfdvg rasfrsa" ) )
    
    bibliography_file_path = "../ThesisToLatex/Thesis.bib"
    if os.path.exists( bibliography_file_path ):
        print( "bibliography_file_path: " + bibliography_file_path )
        bibliography_file = open( bibliography_file_path, 'r' )
        bibliography_file_text = bibliography_file.read()
        
        pattern_cite   = re.compile(r'%% C (\d+)\n\@[^\{]+\{([^,]+)')
        all_cites      = re.findall( pattern_cite, bibliography_file_text )

        for cite_number, cite_id in all_cites:
            print("cite_number: " + cite_number + " to: " + cite_id)
            source_before_references = re.sub( r"\\cite\{" + cite_number + "\}", "\\cite{" + cite_id + "}", source_before_references )
    
    #print_all_states( source_before_appendix )
    
    source_before_references = latex_escape_characters( source_before_references )
    
    
    pattern_appendix    = re.compile(r'(Appendix (?:\d[\.]?)+)([^\r\n>]+)')
    all_appendixes      = re.findall( pattern_appendix, source_appendix )

    for appendix_name, appendix_title in all_appendixes:
        print( "appendix_name  : " + appendix_name )
        print( "appendix_title : " + appendix_title )
        appendix_link = make_link(appendix_name)
        
        
        sectioning_type = ""
        
        match_level_0 = re.search( r'(Appendix \d)$', appendix_name )
        if match_level_0:
            sectioning_type = "chapter"
        else:
            match_level_1 = re.search( r'(Appendix \d\.\d)$', appendix_name )
            if match_level_1:
                sectioning_type = "section"
            
        
        source_appendix = re.sub( appendix_name + appendix_title, "\\" + sectioning_type + "{ " + appendix_title + "}" + "\\label{" + appendix_link + "} ", source_appendix )
        
        source_before_references = re.sub( "<" + appendix_name + ">", "Appendix \\\\ref{" + appendix_link + "}", source_before_references )
    
    
    pattern_bullets_block   = re.compile(r'((?:(?:[ \t]*\\item [^\r\n]+)(?:\r\n)+)+)')
    all_bullets_blocks      = re.findall( pattern_bullets_block, source_before_references )

    block_number = 0
    for bullets_block in all_bullets_blocks:
        print("block_number: " + str(block_number) )
        print( bullets_block )
        source_before_references = source_before_references.replace( bullets_block, "\\begin{itemize}\r\n" + bullets_block + "\\end{itemize}\r\n" )
        block_number = block_number + 1
    
    source_before_references = re.sub( r"(\r\n[ \t]*)+\r\n", "\r\n", source_before_references )
    source_before_references = source_before_references.replace( "\r\n", "\\\\\r\n" )
    
    #print( re.findall( r"\r\n(\d [A-Z\\][^\r\n]+)\\\\\r\n", source_before_references ) )
    
    
    source_before_references = re.sub( r"\n[ \t]*\d+ ([A-Z\\][^\r\n]+)\\\\\r",                        "\n\\chapter{\\1}\r",       source_before_references )
    source_before_references = re.sub( r"\n[ \t]*\d\.\d+\.? ([A-Z\\][^\r\n]+)\\\\\r",                 "\n\\section{\\1}\r",       source_before_references )
    source_before_references = re.sub( r"\n[ \t]*\d\.\d+\.\d+\.? ([A-Z\\][^\r\n]+)\\\\\r",            "\n\\subsection{\\1}\r",    source_before_references )
    source_before_references = re.sub( r"\n[ \t]*\d\.\d+\.\d+\.\d+\.? ([A-Z\\][^\r\n]+)\\\\\r",       "\n\\subsubsection{\\1}\r", source_before_references )
    source_before_references = re.sub( r"\n[ \t]*\d\.\d+\.\d+\.\d+\.\d+\.? ([A-Z\\][^\r\n]+)\\\\\r",  "\n\\paragraph{\\1}\r",     source_before_references )
    

    source_before_references = re.sub( r"\\item(?:[\r\n \t])*\\\\(?:[\r\n \t])*",   "\r\n\\item " , source_before_references )
    source_before_references = re.sub( r"\\item(?:[ \t]*(?:[\r][\n])+[ \t]*)+",     "\r\n\\item " , source_before_references )
    #source_before_references = re.sub( r"\\begin\{enumerate\}(?:[\r\n \t])*\\\\(?:[\r\n \t])*"  , "\r\n\\begin{enumerate} ", source_before_references )
    #source_before_references = re.sub( r"\\end\{enumerate\} (?:[\r\n \t])*\\\\(?:[\r\n \t])*"   , "\r\n\\begin{enumerate} ", source_before_references )

    # Preliminary access
    source_before_references = re.sub( r"(\\item [^\r\n]*)\\\\",        "\\1", source_before_references )
    source_before_references = re.sub( r"\\\\(\r\n\\item)",             "\\1", source_before_references )
    source_before_references = re.sub( r"(\\begin[^\r\n]*)\\\\",        "\\1", source_before_references )
    source_before_references = re.sub( r"\\\\(\r\n\\begin)",            "\\1", source_before_references )
    source_before_references = re.sub( r"(\\end[^\r\n]*)\\\\",          "\\1", source_before_references )
    source_before_references = re.sub( r"\\\\(\r\n\\end)",              "\\1", source_before_references )

    source_before_references = re.sub( r"\r\n\\item \d\. "                          , "\r\n\\item " ,                   source_before_references )
    source_before_references = re.sub( r"([^\r\n\t ])[ \t]*\\begin{enumerate}"       , "\\1\r\n\\\\begin{enumerate}" ,     source_before_references )
    source_before_references = re.sub( r"([^\r\n\t ])[ \t]*\\end{enumerate}"         , "\\1\r\n\\\\end{enumerate}" ,       source_before_references )
    
    source_before_references = re.sub( r"([^\r\n\t ])[ \t]*\\begin{enumerate}"       , "\\1\r\n\\\\begin{enumerate}" ,     source_before_references )
    source_before_references = re.sub( r"([^\r\n\t ])[ \t]*\\end{enumerate}"         , "\\1\r\n\\\\end{enumerate}" ,       source_before_references )

    source_before_references = re.sub( r"#", "\#", source_before_references )
    
    source_before_references = re.sub( r"\\\\(\r\n\\\\)"                            ,   "\\1"       ,   source_before_references )
    #source_before_references = re.sub( r"(\})\\\\(\r\n)"                           ,   "\\1\\2"    ,   source_before_references )
    source_before_references = re.sub( r"\\begin\{comment\}[^\}]*\\end\{comment\}[\r\n\t]*" ,   ""          ,   source_before_references )
    source_before_references = re.sub( r"\}\\\\[\r\n\t ]+\{"                        ,   "}{"        ,   source_before_references ) # for tableImage
    source_before_references = re.sub( r"(\\clearpage)\\\\"                         ,   "\\1"       ,   source_before_references )
    source_before_references = re.sub( r"\\\\([\r\n]*\\par)"                        ,   "\\1"       ,   source_before_references )
    source_before_references = re.sub( r"\\\\(\r\n)*$"                              ,   ""          ,   source_before_references )

    
    pattern_code_block   = re.compile(r"(\\begin\{lstlisting\}(?:[^\\]*\\\\)*[^\\]*\\end\{lstlisting\})")
    all_code_blocks      = re.findall( pattern_code_block, source_before_references )

    code_block_number = 0
    for code_block in all_code_blocks:
        print("code_block_number: " + str(code_block_number) )
        print( code_block )
        without_new_lines = re.sub( r"\\\\", "", code_block )
        print( without_new_lines )
        
        source_before_references = source_before_references.replace( code_block, without_new_lines )
        code_block_number = code_block_number + 1
    
    
    
    delimiter_introduction  = "\\chapter{Introduction}"
    source_before_introduction, source_after_introduction   = source_before_references.split( delimiter_introduction )
    
    delimiter_abstract      = "\\chapter{Abstract}"
    source_before_abstract, source_after_abstract   = source_before_introduction.split( delimiter_abstract )

    file_output_text_abstract_tex   = source_after_abstract
    file_output_text_main_tex       = delimiter_introduction + source_after_introduction
    file_output_text_appendix_tex   = source_appendix
    
    appendices_text += file_output_text_appendix_tex
    
    file_main_tex.write(file_output_text_main_tex)
    file_main_tex.close()

    file_input_text_abstract_tex = file_abstract_tex.read()
    file_abstract_tex.close()
    file_abstract_tex = open( file_abstract_tex_path, 'w' )
    
    file_input_text_abstract_tex = re.sub( r"%%% ABSTRACT_REPLACE_START %%%[^%]+%%% ABSTRACT_REPLACE_END %%%", 
                                     "%%% ABSTRACT_REPLACE_START %%% %%% ABSTRACT_REPLACE_END %%%", file_input_text_abstract_tex )
                                     
    file_output_text_abstract_tex = file_input_text_abstract_tex.replace( "%%% ABSTRACT_REPLACE_START %%% %%% ABSTRACT_REPLACE_END %%%", 
                                                             "%%% ABSTRACT_REPLACE_START %%%\r" + file_output_text_abstract_tex + "\r%%% ABSTRACT_REPLACE_END %%%" )
    
    file_abstract_tex.write(file_output_text_abstract_tex)
    file_abstract_tex.close()
    
    file_appendices_tex.write( appendices_text )
    file_appendices_tex.close()
    
    print("Done")
    
    
main()
