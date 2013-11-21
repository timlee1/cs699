%{
#include "config.h"

void yyerror(const char *str)
{
	fprintf(stderr, "Error: %s\n", str);
}

int yywrap()
{
	return 1;
}

NVARS var_name_to_nenum(char *var)
{
	if (strcmp(var, "RAND_INIT") == 0) return eRAND_INIT;
	if (strcmp(var, "MAX_FLOW_RETRY") == 0) return eMAX_FLOW_RETRY;
	if (strcmp(var, "MAX_PACKET_SIZE") == 0) return eMAX_PACKET_SIZE;
	if (strcmp(var, "PACKET_TX_TIME") == 0) return ePACKET_TX_TIME;
	if (strcmp(var, "ACK_TIMEOUT") == 0) return eACK_TIMEOUT;
	if (strcmp(var, "DATA_RATE") == 0) return eDATA_RATE;
	if (strcmp(var, "CONTROL_SLOT_DURATION") == 0) return eCONTROL_SLOT_DURATION;
	if (strcmp(var, "CONTENTION_SLOT_DURATION") == 0) return eCONTENTION_SLOT_DURATION;
	if (strcmp(var, "DATA_SLOT_DURATION") == 0) return eDATA_SLOT_DURATION;
	if (strcmp(var, "NO_OF_SLOTS") == 0) return eNO_OF_SLOTS;
	if (strcmp(var, "NO_OF_CONTROL_SLOTS") == 0) return eNO_OF_CONTROL_SLOTS;
	if (strcmp(var, "NO_OF_CONTENTION_SLOTS") == 0) return eNO_OF_CONTENTION_SLOTS;
	if (strcmp(var, "NO_OF_DATA_SLOTS") == 0) return eNO_OF_DATA_SLOTS;
	if (strcmp(var, "FRAME_DURATION") == 0) return eFRAME_DURATION;
	if (strcmp(var, "DATA_PACKET_SIZE") == 0) return eDATA_PACKET_SIZE;
	if (strcmp(var, "LINK_LEVEL_ACK_SIZE") == 0) return eLINK_LEVEL_ACK_SIZE;
	return 0;
}

SVARS var_name_to_senum(char *var)
{
	if (strcmp(var, "CallAcceptedFile") == 0) return eCallAcceptedFile;
	if (strcmp(var, "FlowsFilePrefix") == 0) return eFlowsFilePrefix;
	if (strcmp(var, "FlowStartTimesFile") == 0) return eFlowStartTimesFile;
	if (strcmp(var, "NodeLogFilePrefix") == 0) return eNodeLogFilePrefix;
	if (strcmp(var, "StoreCapFilePrefix") == 0) return eStoreCapFilePrefix;
	if (strcmp(var, "GlobalFlowFilePrefix") == 0) return eGlobalFlowFilePrefix;
	if (strcmp(var, "MobilityFilePrefix") == 0) return eMobilityFilePrefix;
	if (strcmp(var, "ChannelInfoFile") == 0) return eChannelInfoFile;
	if (strcmp(var, "SimulatedCallsFile") == 0) return eSimulatedCallsFile;
	if (strcmp(var, "AdmittedCallsFile") == 0) return eAdmittedCallsFile;
	if (strcmp(var, "ScheduleInfoFile") == 0) return eScheduleInfoFile;
	if (strcmp(var, "ResultsFile") == 0) return eResultsFile;
	if (strcmp(var, "CallsDistributionFile") == 0) return eCallsDistributionFile;
	if (strcmp(var, "HopDistributionFile") == 0) return eHopDistributionFile;
	if (strcmp(var, "NodeUpTimeFile") == 0) return eNodeUpTimeFile;
	if (strcmp(var, "EventQueueDumpFile") == 0) return eEventQueueDumpFile;
	if (strcmp(var, "VoiceMessageFile") == 0) return eVoiceMessageFile;
	if (strcmp(var, "FlowSequenceFile") == 0) return eFlowSequenceFile;
	if (strcmp(var, "AutoTearDownFile") == 0) return eAutoTearDownFile;
	if (strcmp(var, "VoiceEndFile") == 0) return eVoiceEndFile;
	if (strcmp(var, "VoiceStartFile") == 0) return eVoiceStartFile;
	if (strcmp(var, "VoiceLogFile") == 0) return eVoiceLogFile;
	return 0;
}

void print(number num)
{
	if (num.type)
		printf("%lf", num.d);
	else
		printf("%ld", num.l);
}
                
%}

%union {
	struct number nval;
	char *sval, *kval;
}

%token <nval> NUMBER
%token <sval> KEY
%token <sval> STRING
%token IncludeCfg
%type <nval> expr


%left '+' '-' '*' '/'

%%

/*config_file: config '\n' IncludeCfg STRING
			{
				next_file = fopen($4, "r");
				if (next_file == NULL)
				{
					fprintf(stderr, "Couldn't open file: %s.\n", $4);
					exit(-1);
				}
				next_state = yy_create_buffer(next_file, YY_BUF_SIZE);
				yy_switch_to_buffer(next_state);
			}
		   | config
		   ;
*/
config: config config_line
	  |
	  ;

config_line: KEY '=' expr '\n'	
			{
				int index = var_name_to_nenum($1);
				if (index)
				{
					nsym[index] = $3; 
					printf("%s = ", $1);
					print(nsym[var_name_to_nenum($1)]);
					printf("\n");
				}
				else
					yyerror("Unkown parameter!");
			}
		   | KEY '=' '"' STRING '"' '\n'
			{ 
				int index = var_name_to_senum($1);
				if (index)
				{	
					ssym[index] = $4; 
					printf("%s = \"%s\"\n", $1, ssym[var_name_to_senum($1)]);
				}
				else
					yyerror("Unkown parameter!");
			}
		   ;

expr: '(' expr ')' 		{ $$ = $2; }
	| expr '+' expr 	
		{ 
			$$.type = $1.type || $3.type; 
			if (!$$.type) 
				$$.d = ($$.l = $1.l + $3.l); 
			else
				$$.d = $1.d + $3.d;
		}
	| expr '-' expr
		{ 
			$$.type = $1.type || $3.type; 
			if (!$$.type) 
				$$.d = ($$.l = $1.l - $3.l); 
			else
				$$.d = $1.d - $3.d;
		}
	| expr '*' expr
		{ 
			$$.type = $1.type || $3.type; 
			if (!$$.type) 
				$$.d = ($$.l = $1.l * $3.l); 
			else
				$$.d = $1.d * $3.d;
		}
	| expr '/' expr
		{ 
			$$.type = $1.type || $3.type; 
			if (!$$.type) 
				$$.d = ($$.l = $1.l / $3.l); 
			else
				$$.d = $1.d / $3.d;
		}
	| KEY				{ $$ = nsym[var_name_to_nenum($1)]; }
	| NUMBER 			{ $$ = $1; }
	;

%%             
/*
int main(void) 
{              
    yyparse(); 
    return 0;  
}              
*/
 