grammar myInterp;

options {
	language = Java;
}

@header {
    // import packages here.
	import java.util.HashMap;
	import java.util.Scanner;
	import java.util.Vector;
}

@members {
    boolean TRACEON = false;
	HashMap<String,Short> memoryShort = new HashMap<String,Short>();
	HashMap<String,Integer> memoryInt = new HashMap<String,Integer>();
	HashMap<String,Float> memoryFloat = new HashMap<String,Float>();
	HashMap<String,Double> memoryDouble = new HashMap<String,Double>();
	HashMap<String,Integer> memoryType = new HashMap<String,Integer>();
	int printscanFlag = 1;
	int caseFlag = 0;
}

program
		:
		type MAIN '(' ')' '{' declarations statements[1] '}'
		{
			if (TRACEON) System.out.println("VOID MAIN () { declarations statements }");
		}
		;

declarations
		:
		(prefix)? type a=Identifier ('=' b=number)? 
		{
			if( !memoryType.containsKey($a.text) ){
				memoryType.put($a.text, $type.type);
				if($b.value != null){
					switch($type.type){
						case 1:
							memoryShort.put($a.text, Short.parseShort($b.value)); 
							break;
						case 2:
							memoryInt.put($a.text, Integer.parseInt($b.value)); 
							break;
						case 4:
							memoryFloat.put($a.text, Float.parseFloat($b.value));
							//System.out.println(memoryFloat.get($a.text));
							break;
						case 5:
							memoryDouble.put($a.text, Double.parseDouble($b.value));
							//System.out.println(memoryDouble.get($a.text));
							break;
					}
				}
			}
		} 
		(',' c=Identifier ('=' d=number)? 
		{
			if( !memoryType.containsKey($c.text) ){
				memoryType.put($c.text, $type.type);
					if($d.value != null){
						switch($type.type){
							case 1:
								memoryShort.put($c.text, Short.parseShort($d.value)); 
								break;
							case 2:
								memoryInt.put($c.text, Integer.parseInt($d.value)); 
								break;
							case 4:
								memoryFloat.put($c.text, Float.parseFloat($d.value));
								//System.out.println(memoryFloat.get($c.text));
								break;
							case 5:
								memoryDouble.put($c.text, Double.parseDouble($d.value));
								//System.out.println(memoryDouble.get($c.text));
								break;
						}
					}
			}
		}
		)* 
		';' declarations
        | 				{ if (TRACEON) System.out.println("declarations: ");} 
		;

prefix
		:
		AUTO			{ if (TRACEON) System.out.println("prefix: auto"); }
		| CONST			{ if (TRACEON) System.out.println("prefix: const"); }
		| STATIC		{ if (TRACEON) System.out.println("prefix: static"); }
		| EXTERN		{ if (TRACEON) System.out.println("prefix: extern"); }
		| SIGNED		{ if (TRACEON) System.out.println("prefix: signed"); }
		| UNSIGNED		{ if (TRACEON) System.out.println("prefix: unsigned"); }
		| ATOMIC		{ if (TRACEON) System.out.println("prefix: atomic"); }
		| VOLATILE		{ if (TRACEON) System.out.println("prefix: volatile"); }
		| RESTRICT		{ if (TRACEON) System.out.println("prefix: restrict"); }
		| REGISTER		{ if (TRACEON) System.out.println("prefix: register"); }
		;

number returns [String value]
		:
		Integer_constant	
		{ 
			$value = $Integer_constant.text;
			//System.out.println(value);
		}
		| Floating_point_constant
		{
			$value = $Floating_point_constant.text;
		}
		| BIN_NUM
		| HEX_NUM
		;

type returns [int type]
		:
		SHORT		{ $type = 1; if (TRACEON) System.out.println("type: short"); }
		| INT		{ $type = 2; if (TRACEON) System.out.println("type: int"); }
		| LONG		{ $type = 3; if (TRACEON) System.out.println("type: long"); }
		| FLOAT		{ $type = 4; if (TRACEON) System.out.println("type: float"); }
		| DOUBLE	{ $type = 5; if (TRACEON) System.out.println("type: double"); }
		| CHAR		{ $type = 6; if (TRACEON) System.out.println("type: char"); }
		| BOOL		{ $type = 7; if (TRACEON) System.out.println("type: bool"); }
		| VOID		{ $type = 8; if (TRACEON) System.out.println("type: void"); }
		| SIGNED	{ $type = 9; if (TRACEON) System.out.println("type: signed"); }
		| UNSIGNED	{ $type = 10; if (TRACEON) System.out.println("type: unsigned"); }
		;

statements[int en] returns [int flag]
		:
		a=statement[en] statements[en]	{ $flag = $a.flag; }
        |
		;


arith_expression[int en] returns [int value, float fvalue, double dvalue, int type]
@init{
	int optype = 0;
	int optype2 = 0;
}
		:
		a=multExpr[en]
		{
			$value = $a.value;
			$fvalue = $a.fvalue;
			$dvalue = $a.dvalue;
			$type = $a.type;
		}
        ( '+' b=multExpr[en]
		{
			if( ($a.type != $b.type) && ($a.type == 5 || $b.type == 5) ){
				$dvalue = $value + $fvalue + $dvalue + $b.value + $b.fvalue + $b.dvalue;
				$value = 0;
				$fvalue = 0;
				$type = 5;
			}			
			else if( ($a.type != $b.type) && ($a.type == 4 || $b.type == 4) ){
				$fvalue = $value + $fvalue + $b.value + $b.fvalue;
				$value = 0;
				$type = 4;
			}
			else{
				$value = $value + $b.value;
				$fvalue = $fvalue + $b.fvalue;
				$dvalue = $dvalue + $b.dvalue;
				$type = $b.type;
			}			

			if (TRACEON) System.out.println("operation: addition");
		}
		| '-' c=multExpr[en]
		{
			if( ($a.type != $c.type) && ($a.type == 5 || $c.type == 5) ){
				$dvalue = $value + $fvalue + $dvalue - ($c.value + $c.fvalue + $c.dvalue);
				$value = 0;
				$fvalue = 0;
				$type = 5;
			}	
			else if( ($a.type != $c.type) && ($a.type == 4 || $c.type == 4) ){
				$fvalue = $value + $fvalue - ($c.value + $c.fvalue);
				$value = 0;
				$type = 4;
			}
			else{
				$value = $value - $c.value; 
				$fvalue = $fvalue - $c.fvalue;
				$dvalue = $dvalue - $c.dvalue; 
				$type = $c.type;
			}
			
			if (TRACEON) System.out.println("operation: subtract");
		}
		)*
        ;

multExpr[int en] returns [int value, float fvalue, double dvalue, int type]
		: 
		a=signExpr[en]
		{
			$value = $a.value;
			$fvalue = $a.fvalue;
			$dvalue = $a.dvalue;
			$type = $a.type;
		}
        ( '*' b=signExpr[en]
		{
			if( ($a.type != $b.type) && ($a.type == 5 || $b.type == 5) ){
				$dvalue = $value + $fvalue + $dvalue * ($b.value + $b.fvalue + $b.dvalue);
				$value = 0;
				$fvalue = 0;
				$type = 5;
			}	
			else if( ($a.type != $b.type) && ($a.type == 4 || $b.type == 4) ){
				$fvalue = ($value + $fvalue) * ($b.value + $b.fvalue);
				$value = 0;
				$type = 4;
			}
			else{
				$value = $value * $b.value;
				$fvalue = $fvalue * $b.fvalue;
				$dvalue = $dvalue * $b.dvalue;
				$type = $b.type;
			}
			
			if (TRACEON) System.out.println("operation: multiply");
		}
        | '/' c=signExpr[en]
		{
			if( ($a.type != $c.type) && ($a.type == 5 || $c.type == 5) ){
				$dvalue = $value + $fvalue + $dvalue / ($c.value + $c.fvalue + $c.dvalue);
				$value = 0;
				$fvalue = 0;
				$type = 5;
			}	
			else if( ($a.type != $c.type) && ($a.type == 4 || $c.type == 4) ){
				$fvalue = ($value + $fvalue) / ($c.value + $c.fvalue);
				$value = 0;
				$type = 4;
			}
			else{
				$value = $value / $c.value;
				$fvalue = $fvalue / $c.fvalue;
				$dvalue = $dvalue / $c.dvalue;
				$type = $c.type;
			}
			if (TRACEON) System.out.println("operation: division");
		}
		| '%' d=signExpr[en]
		{
			if($a.type == $d.type){
				if($d.value != 0){
					int tmp = $value / $d.value;
					$value = $value - tmp * $d.value;
				}
				if($d.fvalue != 0){
					float tmp2 = $fvalue / $d.fvalue;
					$fvalue = $fvalue - tmp2 * $d.fvalue;
				}
				if($d.dvalue != 0){
					double tmp3 = $dvalue / $d.dvalue;
					$dvalue = $dvalue - tmp3 * $d.dvalue;
				}
				$type = $d.type;
			}
			if (TRACEON) System.out.println("operation: mod");
		}
		)*
		;

signExpr[int en] returns [int value, float fvalue, double dvalue, int type]
		: 
		primaryExpr[en]
		{ 
			$value = $primaryExpr.value;
			$fvalue = $primaryExpr.fvalue;
			$dvalue = $primaryExpr.dvalue;
			$type = $primaryExpr.type;
		}
		| ('++')=> '++' Identifier
		{ 
			if(en == 1){
				$type = memoryType.get($Identifier.text);
				//System.out.printf("\%s : \%d\n", $Identifier.text, $type);
				switch($type){
					case 2:
						if(memoryInt.containsKey($Identifier.text))					
							$value = memoryInt.get($Identifier.text) + 1;
							memoryInt.put($Identifier.text, $value);
						break;
					case 4:
						if(memoryFloat.containsKey($Identifier.text))
							$fvalue = memoryFloat.get($Identifier.text) + 1;
							memoryFloat.put($Identifier.text, $fvalue);
						break;
					case 5:
						if(memoryDouble.containsKey($Identifier.text))
							$dvalue = memoryDouble.get($Identifier.text) + 1;
							memoryDouble.put($Identifier.text, $dvalue);
						break;
				}
			}
			if (TRACEON) System.out.println("primaryExpr: ++id"); 
		}
    	| ('--')=> '--' Identifier
		{	
			if(en == 1){
				$type = memoryType.get($Identifier.text);
				//System.out.printf("\%s : \%d\n", $Identifier.text, $type);
				switch($type){
					case 2:
						if(memoryInt.containsKey($Identifier.text))					
							$value = memoryInt.get($Identifier.text) - 1;
							memoryInt.put($Identifier.text, $value);
						break;
					case 4:
						if(memoryFloat.containsKey($Identifier.text))
							$fvalue = memoryFloat.get($Identifier.text) - 1;
							memoryFloat.put($Identifier.text, $fvalue);
						break;
					case 5:
						if(memoryDouble.containsKey($Identifier.text))
							$dvalue = memoryDouble.get($Identifier.text) - 1;
							memoryDouble.put($Identifier.text, $dvalue);
						break;
				}
			}
			if (TRACEON) System.out.println("primaryExpr: --id");
		}
		| ('-') => ('-') Identifier
		{
			if(en == 1){
				$type = memoryType.get($Identifier.text);
				//System.out.printf("\%s : \%d\n", $Identifier.text, $type);
				switch($type){
					case 2:
						if(memoryInt.containsKey($Identifier.text))					
							$value = memoryInt.get($Identifier.text) * -1;
						break;
					case 4:
						if(memoryFloat.containsKey($Identifier.text))
							$fvalue = memoryFloat.get($Identifier.text) * -1;
						break;
					case 5:
						if(memoryDouble.containsKey($Identifier.text))
							$dvalue = memoryDouble.get($Identifier.text) * -1;
						break;
				}
			} 
			if (TRACEON) System.out.println("signExpr"); 
		}
		| ('!') => '!' Identifier							{ if (TRACEON) System.out.println("primaryExpr: !"); } 
		| ('~') => '~' Identifier
		{ 
			if(en == 1){
				$type = memoryType.get($Identifier.text);
				//System.out.printf("\%s : \%d\n", $Identifier.text, $type);
				switch($type){
					case 2:
						if(memoryInt.containsKey($Identifier.text))					
							$value = ~memoryInt.get($Identifier.text);
						break;
				}
			} 
			if (TRACEON) System.out.println("primaryExpr: ~"); 
		}		
		;
		  
primaryExpr[int en] returns [int value, float fvalue, double dvalue, int type]
@init{
	int optype = 0;
}		
		: 
		Integer_constant	
		{ 
			$value = Integer.parseInt($Integer_constant.text); 
			$type = 2;
		}
        | Floating_point_constant
		{ 
			$fvalue = Float.parseFloat($Floating_point_constant.text); 
			$type = 4;
		}
        | Identifier
		{
			
			$type = memoryType.get($Identifier.text);
			//System.out.printf("\%s : \%d\n", $Identifier.text, $type);
			switch($type){
				case 2:
					if(memoryInt.containsKey($Identifier.text))					
						$value = memoryInt.get($Identifier.text);
					break;
				case 4:
					if(memoryFloat.containsKey($Identifier.text))
						$fvalue = memoryFloat.get($Identifier.text);
					break;
				case 5:
					if(memoryDouble.containsKey($Identifier.text))
						$dvalue = memoryDouble.get($Identifier.text);
					break;
			}
		}
		| Identifier ('++' { optype = 1; if (TRACEON) System.out.println("primaryExpr: id++"); } | '--' { optype = 2; if (TRACEON) System.out.println("primaryExpr: id--"); })
		{
			if(en == 1){
				$type = memoryType.get($Identifier.text);
				//System.out.printf("\%s : \%d\n", $Identifier.text, $type);
				switch($type){
					case 2:
						if(memoryInt.containsKey($Identifier.text))					
							$value = memoryInt.get($Identifier.text);
							if(optype == 1)
								memoryInt.put($Identifier.text, $value+1);
							else if(optype == 2)				
								memoryInt.put($Identifier.text, $value-1);
						break;
					case 4:
						if(memoryFloat.containsKey($Identifier.text))
							$fvalue = memoryFloat.get($Identifier.text);
							if(optype == 1)
								memoryFloat.put($Identifier.text, $fvalue+1);
							else if(optype == 2)				
								memoryFloat.put($Identifier.text, $fvalue-1);
						break;
					case 5:
						if(memoryDouble.containsKey($Identifier.text))
							$dvalue = memoryDouble.get($Identifier.text);
							if(optype == 1)
								memoryDouble.put($Identifier.text, $dvalue+1);
							else if(optype == 2)				
								memoryDouble.put($Identifier.text, $dvalue-1);
						break;
				}
			}
		}			
		| '(' conditional[en] ')'
		{
			$value = $conditional.value;
			$fvalue = $conditional.fvalue;
			$dvalue = $conditional.dvalue;
			$type = $conditional.type;
		}
		//| Identifier '[' Integer_constant ']'		{ if (TRACEON) System.out.println("primaryExpr: []"); }
        ;

expression[int en] returns [int value, float fvalue, double dvalue, int type, int flag]
    	:
		a=assignment[en]
		{
			$value = $a.value;
			$fvalue = $a.fvalue;
			$dvalue = $a.dvalue;
			$type = $a.type;
			$flag = $a.flag;
		}
		(',' assignment[en] )*
    	;

assignment[int en] returns [int value, float fvalue, double dvalue, int type, int flag]
    	: 
		Identifier operator a=assignment[en]
		{
			int IDtype = memoryType.get($Identifier.text);
			if(en == 1){
				switch($operator.op){
					case 1:		// =
						if(IDtype == 2){			
							memoryInt.put($Identifier.text, $a.value);
							//System.out.println($Identifier.text+":"+$a.value);
						}
						else if(IDtype == 4){			
							memoryFloat.put($Identifier.text, $a.value + $a.fvalue);
							//System.out.println($a.fvalue);
						}
						else if(IDtype == 5){			
							memoryDouble.put($Identifier.text, $a.value + $a.fvalue + $a.dvalue);
							//System.out.println($a.dvalue);
						}
						break;
					case 2:		// +=
						if(IDtype == 2){	
							int tmp = memoryInt.get($Identifier.text);
							memoryInt.put($Identifier.text, tmp + $a.value);
						}
						else if(IDtype == 4){
							float tmp = memoryFloat.get($Identifier.text);	
							memoryFloat.put($Identifier.text, tmp + $a.value + $a.fvalue);
							//System.out.println(memoryFloat.get($Identifier.text));
						}
						else if(IDtype == 5){
							double tmp = memoryDouble.get($Identifier.text);	
							memoryDouble.put($Identifier.text, tmp + $a.value + $a.fvalue + $a.dvalue);
							//System.out.println(memoryDouble.get($Identifier.text));
						}
						break;
					case 3:		// -=
						if(IDtype == 2){	
							int tmp = memoryInt.get($Identifier.text);
							memoryInt.put($Identifier.text, tmp - $a.value);
						}
						else if(IDtype == 4){
							float tmp = memoryFloat.get($Identifier.text);	
							memoryFloat.put($Identifier.text, tmp - ($a.value + $a.fvalue) );
						}
						else if(IDtype == 5){
							double tmp = memoryDouble.get($Identifier.text);	
							memoryDouble.put($Identifier.text, tmp - ($a.value + $a.fvalue + $a.dvalue) );
						}
						break;
					case 4:		// *=
						if(IDtype == 2){	
							int tmp = memoryInt.get($Identifier.text);
							memoryInt.put($Identifier.text, tmp * $a.value);
						}
						else if(IDtype == 4){
							float tmp = memoryFloat.get($Identifier.text);	
							memoryFloat.put($Identifier.text, tmp * ($a.value+$a.fvalue) );
						}
						else if(IDtype == 5){
							double tmp = memoryDouble.get($Identifier.text);	
							memoryDouble.put($Identifier.text, tmp * ($a.value+$a.fvalue+$a.dvalue) );
						}
						break;
					case 5:		// /=
						if(IDtype == 2){	
							int tmp = memoryInt.get($Identifier.text);
							memoryInt.put($Identifier.text, tmp / $a.value);
						}
						else if(IDtype == 4){
							float tmp = memoryFloat.get($Identifier.text);	
							memoryFloat.put($Identifier.text, tmp / ($a.value+$a.fvalue) );
						}
						else if(IDtype == 5){
							double tmp = memoryDouble.get($Identifier.text);	
							memoryDouble.put($Identifier.text, tmp / ($a.value+$a.fvalue+$a.dvalue) );
						}
						break;
					case 6:		// \%=
						if(IDtype == 2){	
							int tmp = memoryInt.get($Identifier.text);
							int tmp2 = tmp / $a.value;
							memoryInt.put($Identifier.text, tmp - tmp2 * $a.value);
						}
						break;
					case 7:		// <<=
						if(IDtype == 2){	
							int tmp = memoryInt.get($Identifier.text);
							memoryInt.put($Identifier.text, tmp << $a.value);
						}
						break;
					case 8:		// >>=
						if(IDtype == 2){	
							int tmp = memoryInt.get($Identifier.text);
							memoryInt.put($Identifier.text, tmp >> $a.value);
						}
						break;
					case 9:		// &=
						if(IDtype == 2){	
							int tmp = memoryInt.get($Identifier.text);
							memoryInt.put($Identifier.text, tmp & $a.value);
						}
						break;
					case 10:	// |=
						if(IDtype == 2){	
							int tmp = memoryInt.get($Identifier.text);
							memoryInt.put($Identifier.text, tmp | $a.value);
						}
						break;
					case 11:	// ^=
						if(IDtype == 2){	
							int tmp = memoryInt.get($Identifier.text);
							memoryInt.put($Identifier.text, tmp ^ $a.value);
						}
						break;
				}
			}
		}
    	| conditional[en]
		{
			$value = $conditional.value;
			$fvalue = $conditional.fvalue;
			$dvalue = $conditional.dvalue;
			$type = $conditional.type;
			$flag = $conditional.flag;
		}
    	;

conditional[int en] returns [int value, float fvalue, double dvalue, int type, int flag]
@init{
	int first = 0;
	int second = 0;
}    	
		:
		a=or_or[en]
		{ 
			$value = $a.value;
			$fvalue = $a.fvalue;
			$dvalue = $a.dvalue;
			$type = $a.type; 
			$flag = $a.flag;
		}
		('?' 
		{
			if($a.flag == 1)
				first = 1;
			else
				second = 1;
			//System.out.println(first+":"+second);
		}		
		assignment[first] ':' assignment[second] { if (TRACEON) System.out.println("relation: ? expression : conditional"); })?
    	;

or_or[int en] returns [int value, float fvalue, double dvalue, int type, int flag]
    	:
		a=and_and[en]
		{ 
			$value = $a.value;
			$fvalue = $a.fvalue;
			$dvalue = $a.dvalue;
			$type = $a.type; 
			$flag = $a.flag;
		}
		('||' b=and_and[en]
		{
			if($a.flag == 1 || $b.flag == 1){
				$flag = 1;
				//System.out.println("match");
			}
			if (TRACEON) System.out.println("relation: ||");
		}
		)*
    	;

and_and[int en] returns [int value, float fvalue, double dvalue, int type, int flag]
    	:
		a=inclusive_or[en]
		{ 
			$value = $a.value;
			$fvalue = $a.fvalue;
			$dvalue = $a.dvalue;
			$type = $a.type; 
			$flag = $a.flag;
		}
		('&&' b=inclusive_or[en]
		{
			if($a.flag == 0 || $b.flag == 0)
				$flag = 0;
			else
				$flag = 1;
			if (TRACEON) System.out.println("relation: &&");
		}
		)*
    	;

inclusive_or[int en] returns [int value, float fvalue, double dvalue, int type, int flag]
    	:
		a=exclusive_or[en]
		{ 
			$value = $a.value;
			$fvalue = $a.fvalue;
			$dvalue = $a.dvalue;
			$type = $a.type; 
			$flag = $a.flag;
		}
		('|' b=exclusive_or[en]
		{
			if($a.type == 2 && $b.type == 2){
				$value = $a.value | $b.value;
				$type = $b.type;
			}
			if (TRACEON) System.out.println("relation: |");
		}
		)*
    	;

exclusive_or[int en] returns [int value, float fvalue, double dvalue, int type, int flag]
    	:
		a=single_and[en]
		{ 
			$value = $a.value;
			$fvalue = $a.fvalue;
			$dvalue = $a.dvalue;
			$type = $a.type; 
			$flag = $a.flag;
		}
		('^' b=single_and[en]
		{
			if($a.type == 2 && $b.type == 2){
				$value = $a.value ^ $b.value;
				$type = $b.type;
			}
			if (TRACEON) System.out.println("relation: ^");
		}
		)*
    	;

single_and[int en] returns [int value, float fvalue, double dvalue, int type, int flag]
    	:
		a=equal[en]
		{ 
			$value = $a.value;
			$fvalue = $a.fvalue;
			$dvalue = $a.dvalue;
			$type = $a.type; 
			$flag = $a.flag;
		}
		('&' b=equal[en]
		{
			if($a.type == 2 && $b.type == 2){
				$value = $a.value & $b.value;
				$type = $b.type;
			}
			if (TRACEON) System.out.println("relation: &");
		}
		)*
    	;

equal[int en] returns [int value, float fvalue, double dvalue, int type, int flag]
@init{
	int optype = 0;
}
    	:
		a=relational[en]
		{ 
			$value = $a.value;
			$fvalue = $a.fvalue;
			$dvalue = $a.dvalue;
			$type = $a.type;
			$flag = $a.flag;
		}		
		(('==' { optype = 1; if (TRACEON) System.out.println("relation: =="); } 
		| '!=' { optype = 2; if (TRACEON) System.out.println("relation: !="); } ) b=relational[en]
		{ 
			if(optype == 1){
				switch($a.type){
					case 2:					
						if($a.value == $b.value) $flag = 1;
						break;
					case 4:					
						if( ($a.value+$a.fvalue) == ($b.value+$b.fvalue) ) $flag = 1;
						break;
					case 5:					
						if( ($a.value+$a.fvalue+$a.dvalue) == ($b.value+$b.fvalue+$b.dvalue) ) $flag = 1;
						break;
				}
			}
			else if(optype == 2){
				switch($a.type){
					case 2:					
						if($a.value!=$b.value) $flag = 1;
						break;
					case 4:					
						if( ($a.value+$a.fvalue) != ($b.value+$b.fvalue) ) $flag = 1;
						break;
					case 5:
						if( ($a.value+$a.fvalue+$a.dvalue) != ($b.value+$b.fvalue+$b.dvalue) ) $flag = 1;
						break;
				}
			}
		} 
		)*
    	;

relational[int en] returns [int value, float fvalue, double dvalue, int type, int flag]
@init{
	int optype = 0;
}		
		:
		a=shift[en]
		{ 
			$value = $a.value;
			$fvalue = $a.fvalue;
			$dvalue = $a.dvalue;
			$type = $a.type;
			$flag = $a.flag; 
		}	
		(
		( 
		  '<=' { optype = 3; if (TRACEON) System.out.println("relation: <="); } 
		| '>=' { optype = 4; if (TRACEON) System.out.println("relation: >="); }
		| '<' { optype = 1; if (TRACEON) System.out.println("relation: <"); } 
		| '>' { optype = 2; if (TRACEON) System.out.println("relation: >"); } ) b=shift[en]
		{ 
			if(optype == 1){
				switch($a.type){
					case 2:					
						if($a.value < $b.value) $flag = 1;
						break;
					case 4:					
						if( ($a.value+$a.fvalue) < ($b.value+$b.fvalue) ) $flag = 1;
						break;
					case 5:					
						if( ($a.value+$a.fvalue+$a.dvalue) < ($b.value+$b.fvalue+$b.dvalue) ) $flag = 1;
						break;
				}
			}			
			else if(optype == 2){
				switch($a.type){
					case 2:					
						if($a.value > $b.value) $flag = 1;
						break;
					case 4:					
						if( ($a.value+$a.fvalue) > ($b.value+$b.fvalue) ) $flag = 1;
						break;
					case 5:
						if( ($a.value+$a.fvalue+$a.dvalue) > ($b.value+$b.fvalue+$b.dvalue) ) $flag = 1;
						break;
				}
			}
			else if(optype == 3){
				switch($a.type){
					case 2:					
						if($a.value <= $b.value) $flag = 1;
						//System.out.println($a.value + ":" + $b.value);
						break;
					case 4:					
						if( ($a.value+$a.fvalue) <= ($b.value+$b.fvalue) ) $flag = 1;
						break;
					case 5:					
						if( ($a.value+$a.fvalue+$a.dvalue) <= ($b.value+$b.fvalue+$b.dvalue) ) $flag = 1;
						break;
				}
			}
			else if(optype == 4){
				switch($a.type){
					case 2:					
						if($a.value >= $b.value) $flag = 1;
						break;
					case 4:					
						if( ($a.value+$a.fvalue) >= ($b.value+$b.fvalue) ) $flag = 1;
						//System.out.println($a.fvalue + ":" + $b.fvalue);
						break;
					case 5:					
						if( ($a.value+$a.fvalue+$a.dvalue) >= ($b.value+$b.fvalue+$b.dvalue) ) $flag = 1;
						//System.out.println($a.dvalue + ":" + $b.dvalue);
						break;
				}
			}			
		} 		
		)*
    	;

shift[int en] returns [int value, float fvalue, double dvalue, int type, int flag]
@init{
	int optype = 0;
}    	
		: 
		a=arith_expression[en]
		{ 
			$value = $a.value;
			$fvalue = $a.fvalue;
			$dvalue = $a.dvalue;
			$type = $a.type; 
		}
		(('<<' { optype = 1; if (TRACEON) System.out.println("relation: <<"); } 
		| '>>' { optype = 2; if (TRACEON) System.out.println("relation: >>"); } ) b=arith_expression[en]
		{
			if($a.type == 2 && $b.type == 2){
				switch(optype){
					case 1:		
						$value = $a.value << $b.value ;
						break;
					case 2:					
						$value = $a.value >> $b.value ;
						break;
				}
				$type = $b.type;
			}
		}
		)*
    	;


operator returns [int op]
		: 
		'='			{ $op = 1; if (TRACEON) System.out.println("operator: =");}
    	| '+='		{ $op = 2; if (TRACEON) System.out.println("operator: +="); }
    	| '-='		{ $op = 3; if (TRACEON) System.out.println("operator: -="); }
    	| '*='		{ $op = 4; if (TRACEON) System.out.println("operator: *="); }
    	| '/='		{ $op = 5; if (TRACEON) System.out.println("operator: /="); }
    	| '%='		{ $op = 6; if (TRACEON) System.out.println("operator: \%="); }
    	| '<<='		{ $op = 7; if (TRACEON) System.out.println("operator: <<="); }
    	| '>>='		{ $op = 8; if (TRACEON) System.out.println("operator: >>="); }
    	| '&='		{ $op = 9; if (TRACEON) System.out.println("operator: &="); }
    	| '|='		{ $op = 10; if (TRACEON) System.out.println("operator: |="); }
    	| '^='		{ $op = 11; if (TRACEON) System.out.println("operator: ^="); }
    	;

statement[int en] returns [int flag]
@init{
	int elseifFlag = 0;
	int elseFlag = 0;
	int defaultFlag = 0;
	String literal = "";
	int scanIndex = 0;
	String scan = "";
}
		: 
		expression[en]  ';'
		//| Identifier '=' arith_expression ';'																{ if (TRACEON) System.out.println("assignment"); }
        | 	IF '(' a=expression[1] ')' 
			{
				if($a.flag == 0)
					printscanFlag = 0;
			}
			then_statements[$a.flag]
			{
				if (TRACEON) System.out.println("end of if");
			}

			((ELSE IF)=> ELSE IF '(' b=expression[1] ')' 
			{
				if( $a.flag == 0 && $b.flag == 1 && elseifFlag == 0 ){
					elseFlag = 1;
					elseifFlag = 1;
					printscanFlag = 1;
				}
				else{
					elseFlag = 0;
					printscanFlag = 0;
				}
			}
			then_statements[elseFlag]
			)*

			{ 
				if( $a.flag == 0 && elseifFlag == 0 ){
					elseFlag = 1;
					printscanFlag = 1;				
				}
				else{
					elseFlag = 0;
					printscanFlag = 0;
				}
				if (TRACEON) System.out.println("end of else if");
			}
			( (ELSE)=> ELSE then_statements[elseFlag] { if (TRACEON) System.out.println("end of else"); } )?
			{
				printscanFlag = 1;
				elseifFlag = 0;
				elseFlag = 0;		
			}		
			
		| SWITCH '(' a=expression[1] ')' '{' ( switch_statements[$a.value, $a.fvalue, $a.dvalue, $a.type])*
		( DEFAULT ':' 
		{
			if(caseFlag == 0){
				defaultFlag = 1;
				printscanFlag = 1;
			}
			else{
				defaultFlag = 0;
				printscanFlag = 0;
			}
		}
		statements[defaultFlag] BREAK ';' )? '}'
		{
			printscanFlag = 1;
			caseFlag = 0; 
			if (TRACEON) System.out.println("end of switch"); 
		}
		//| CASE conditional ':' statements[0] BREAK ';'													{ if (TRACEON) System.out.println("case"); }
    	//| DEFAULT ':' statements[0] BREAK ';'																{ if (TRACEON) System.out.println("default"); }

		| WHILE '(' expression[0] ')' then_statements[0]													{ if (TRACEON) System.out.println("end of while"); }
    	| DO then_statements[0] WHILE '(' expression[0] ')' ';'												{ if (TRACEON) System.out.println("end of do while"); }
    	| FOR '(' expression[0]? ';' expression[0]? ';' expression[0]? ')' then_statements[0]				{ if (TRACEON) System.out.println("end of for"); }
		 
    	| CONTINUE ';'																						{ if (TRACEON) System.out.println("continue"); }
    	//| BREAK ';'
    	| RETURN expression[0]? ';'																			{ if (TRACEON) System.out.println("return"); }

		| 'goto' Identifier ';'																				{ if (TRACEON) System.out.println("goto"); }
 		| Identifier ':' statement[0]																		{ if (TRACEON) System.out.println("goto anchor"); }

		| PRINTF 
			'(' Literal1			{ literal = $Literal1.text; literal = literal.replaceAll("\"", ""); } 
			(',' io_then_statement 	
			{ 
				if($io_then_statement.ID == "sizeof"){
					literal = literal.replaceFirst("\%d", $io_then_statement.value);
				}
				else{
					switch($io_then_statement.type){
						case 2:
							literal = literal.replaceFirst("\%d", $io_then_statement.value);
							break;
						case 4:
							literal = literal.replaceFirst("\%f", $io_then_statement.value);
							break;
						case 5:
							literal = literal.replaceFirst("\%lf", $io_then_statement.value);
							break;
					}
				 }
			} 
			)* 
			')' ';'
			{
				if ( literal.indexOf("\\n") < 0 && printscanFlag == 1)
   					System.out.print(literal);
     			else if( printscanFlag == 1 ){
					String stringArray[] = literal.split("\\\\n");
					for(int i = 0; i < stringArray.length; i++)     				
						System.out.println(stringArray[i]);     
				}       
				if (TRACEON) System.out.println("printf"); 
			}

		| SCANF 
			'(' Literal1
			{ 
				literal = $Literal1.text;
				literal = literal.replaceAll("\"", "");
				scanIndex = 0;
				char[] array = literal.toCharArray();
				char[] tmp = new char[array.length];
				for(int i = 0; i < array.length; i++){
					if(array[i++] != '\%')	continue;
					//System.out.println("Type : " + array[i]);	
					tmp[scanIndex++] = array[i];
					
					if(array[i] == 'l')
						tmp[scanIndex++] = array[++i];
				}
				scanIndex = 0;

				scan = new String(tmp);
			} 
			(',''&' scanf_statment  	
			{
				Scanner scanner = new Scanner(System.in);
				//System.out.println(scan);	
				
				if(printscanFlag == 1){
					switch(scan.charAt(scanIndex++)){
						case 'd':
							int num = scanner.nextInt(); 
							//System.out.println("Input : " + num);
							memoryInt.put($scanf_statment.ID, num);
							break;
						case 'f':
							float num2 = scanner.nextFloat(); 
							memoryFloat.put($scanf_statment.ID, num2);
							break;
						case 'l':
							if(scan.charAt(scanIndex++) != 'f')		break;
							double num3 = scanner.nextDouble(); 
							memoryDouble.put($scanf_statment.ID, num3);
							break;
					}
				}
			} 
			)*
			')' ';'
			{
				if (TRACEON) System.out.println("scanf");
			}
		| type Identifier '(' expression[0]? ')' '{' declarations statements[0] '}'								{ if (TRACEON) System.out.println("end of function"); }
		| ';'
		;

switch_statements[int value, float fvalue, double dvalue, int type]
@init{
	int flag = 0;
}		
		:
		CASE a=conditional[1] ':' 
		{
			flag = 0;
			printscanFlag = 0;

			if(caseFlag == 0){
				if($a.type == 2 && $type == 2){
					if($a.value == $value){
						printscanFlag = 1;
						caseFlag = 1;
						flag = 1;
					}
				}
				else if($a.type == 4 && $type == 4){
					if($a.fvalue == $fvalue){
						printscanFlag = 1;
						caseFlag = 1;
						flag = 1;
					}
				}
				else if($a.type == 5 && $type == 5){
					if($a.dvalue == $dvalue){
						printscanFlag = 1;
						caseFlag = 1;
						flag = 1;
					}
				}
			}
		}
		statements[flag] BREAK ';'														{ if (TRACEON) System.out.println("case"); }
    	;

then_statements[int en] returns [int flag]
		:
		a=statement[en]				{ $flag = $a.flag; }
        | '{' b=statements[en] '}'	{ $flag = $b.flag; }
		;

scanf_statment returns [String ID]
		:
		Identifier
		{
			$ID = $Identifier.text; 
		}
		;

io_then_statement returns [String value, String ID, int type]
@init{
	int optype = 0;
}
		:
		conditional[1]
		{
			$type = $conditional.type;
			switch($type){
				case 2:				
					$value = Integer.toString($conditional.value); 
					break;
				case 4:	
					$value = Float.toString($conditional.value + $conditional.fvalue); 
					break;
				case 5:	
					$value = Double.toString($conditional.value + $conditional.fvalue + $conditional.dvalue); 
					break;
			}
			$ID = "";
		}
		| SIZEOF '(' (a=Identifier { optype = 1; } | b=type { optype = 2; } ) ')'
		{ 
			int type = 0;
			if(optype == 1){
				type = memoryType.get($a.text);
			}
			else if(optype == 2){
				type = $b.type;
			}

			$ID = "sizeof";
			switch(type){
				case 2:
					$value = "4";
					break;
				case 4:
					$value = "4";
					break;
				case 5:
					$value = "8";
					break;
			}
			if (TRACEON) System.out.println("sizeof"); 
		}
		;

/* description of the tokens */

/*----------------------*/
/*      Data Type       */
/*----------------------*/

SHORT : 'short';
INT  : 'int';
LONG : 'long';
FLOAT : 'float';
DOUBLE : 'double';
CHAR : 'char';
BOOL : '_Bool';
VOID : 'void';

/*----------------------*/
/*     Control Flow     */
/*----------------------*/

IF : 'if';
ELSE : 'else';
FOR : 'for';
DO : 'do';
WHILE : 'while';
SWITCH : 'switch';
CASE : 'case';
DEFAULT : 'default';
BREAK : 'break';
CONTINUE : 'continue';
GOTO : 'goto';

/*----------------------*/
/*       Function       */
/*----------------------*/

MAIN : 'main';
PRINTF : 'printf';
SCANF : 'scanf';
TYPEDEF : 'typedef';
SIZEOF : 'sizeof';

/*----------------------*/
/*   Reserved Keywords  */
/*----------------------*/

DEFINE : 'define';
INCLUDE : 'include';
FUNCTION : 'function';
RETURN : 'return';
INLINE : 'inline';
ENUM : 'enum';
UNION : 'union';
STRUCT : 'struct';

AUTO : 'auto';
CONST : 'const';
STATIC : 'static';
EXTERN : 'extern';
SIGNED : 'signed';
UNSIGNED : 'unsigned';
ATOMIC : '_Atomic';
VOLATILE : 'volatile';
RESTRICT : 'restrict';
REGISTER : 'register';

ALIGNAS : '_Alignas';
ALIGNOF : '_Alignof';
COMPLEX : '_Complex';
GENERIC : '_Generic';
IMAGINARY : '_Imaginary';
NORETURN : '_Noreturn';
STATICASSERT : '_Static_assert';
THREADLOCAL : '_Thread_local';

/*----------------------*/
/*      Operators       */
/*----------------------*/

EQUAL : '==';
NOTEQUAL : '!=';

ASSIGN : '=';
PLUSASSIGN : '+=';
MINUSASSIGN : '-=';
MULASSIGN : '*=';
DIVASSIGN : '/=';
MODASSIGN : '%=';
LEFTSHIFTASSIGN : '<<=';
RIGHTSHIFTASSIGN : '>>=';
ANDASSIGN : '&=';
ORASSIGN : '|=';
XORASSIGN : '^=';

LEFTSHIFT : '<<';
RIGHTSHIFT : '>>';
LESSEQUAL : '<=';
GREATEQUAL : '>=';
LESS : '<';
GREAT : '>';

ANDAND : '&&';
OROR : '||';
AND : '&';
OR : '|';
NOT : '!';
CARET : '^';
TILDE : '~';

PLUSPLUS : '++';
MINUSMINUS : '--';
PLUS : '+';
MINUS : '-';
MUL : '*';
DIV : '/';
MOD : '%';

/*----------------------*/
/*        Others        */
/*----------------------*/

LEFTPAREN : '(';
RIGHTPAREN : ')';
LEFTBRACKET : '[';
RIGHTBRACKET : ']';
LEFTBRACE : '{';
RIGHTBRACE : '}';

COMMA : ',';
QUESTION : '?';
COLON : ':';
SEMICOLON : ';';

Identifier:('a'..'z'|'A'..'Z'|'_') ('a'..'z'|'A'..'Z'|'0'..'9'|'_')*;
Integer_constant:'0'..'9'+;
Floating_point_constant:'0'..'9'+ '.' '0'..'9'+;
BIN_NUM : '0'('b' | 'B')('0' | '1')+;
HEX_NUM : '0'('x' | 'X')('0'..'9' | 'a'..'f' | 'A'..'F')+;

Escape : '\\';
COMMENT:'/*' .* '*/' {$channel=HIDDEN;};
COMMENT2:'//' .* '\n' {$channel=HIDDEN;};
Literal1 : '"'(options{greedy=false;}: .)*'"';
Literal2 : '\''(options{greedy=false;}: .)*'\'';
INPORT: '#' .* '\n' {$channel=HIDDEN;};
WS:( ' ' | '\t' | '\r' | '\n' ) {$channel=HIDDEN;};

