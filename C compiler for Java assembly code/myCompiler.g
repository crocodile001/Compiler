grammar myCompiler;

options {
	language = Java;
}

@header {
    /* import packages here */
	import java.util.HashMap;
	import java.util.Scanner;
	import java.util.ArrayList;
}

@members {

    boolean TRACEON = false;

	// =================================================================================== //
	//																					   //
	//  The structure of symbol table:													   //
	//  <variable ID, type, memory location>											   //
	//     - type: the variable type   (please check "enum Type")						   //
	//     - memory location: the location (locals in VM) the variable will be stored at.  //
	//																					   //
    // =================================================================================== //

    HashMap<String, ArrayList> symtab = new HashMap<String, ArrayList>();

	/* storageIndex is used to represent/index the location (locals) in VM. */
	int storageIndex = 0;
	int labelCount = 0;

    /* Record all assembly instructions. */
    List<String> TextCode = new ArrayList<String>();
	List<String> TextCodeCopy;

    public enum Type{
       SHORT, INT, LONG, FLOAT, DOUBLE, CHAR, BOOL, VOID, SIGNED, UNSIGNED;
    }

    /*
     * Output prologue.
     */
	void prologue()
    {
       TextCode.add(";.source");
       TextCode.add(".class public static myResult");
       TextCode.add(".super java/lang/Object");
       TextCode.add(".method public static main([Ljava/lang/String;)V");

       /* The size of stack and locals should be properly set. */
       //TextCode.add(".limit stack 100");
       //TextCode.add(".limit locals 100");
    }
    
	
    /*
     * Output epilogue.
     */
    void epilogue()
    {
        /* handle epilogue */
        TextCode.add("return");
        TextCode.add(".end method");

		/* The size of stack and locals should be properly set. */
       TextCode.add(4, ".limit stack " + (storageIndex+10) );
       TextCode.add(5, ".limit locals " + (storageIndex+10) );
    }
    
    
    /* Generate a new label */
    String newLabel()
    {
       labelCount ++;
       return (new String("L")) + Integer.toString(labelCount);
    } 
    
    
    public List<String> getTextCode()
    {
       return TextCode;
    }			

	int elseCount = 0;
	int endCount = 0;
	int loopCount = 0;

	int caseCount = 0;
	int switchIndex = 0;
}

program
		:
		type MAIN '(' ')'
		{
           /* output function prologue */
           prologue();
        }
		'{' declarations statements '}'
		{
			if (TRACEON) System.out.println("VOID MAIN () { declarations statements }");
			/* output function epilogue */	  
           epilogue();
		}
		;

declarations
		:
		(prefix)? type a=Identifier ('=' b=number)? 
		{
			

			if (symtab.containsKey($a.text)) {
				// variable re-declared.
		        System.out.println("Type Error: " + $a.getLine() + ": Redeclared identifier.");
		        System.exit(0);
		    }
		     
			/* Add ID and its attr_type into the symbol table. */
			ArrayList the_list = new ArrayList();
			the_list.add($type.attr_type);
			the_list.add(storageIndex);
		    symtab.put($a.text, the_list);
			//System.out.println($a.text+" "+storageIndex+" "+$type.attr_type);

			if($b.attr_type != null){

			   	if ($type.attr_type != $b.attr_type) {
					System.out.println("Type Error: Variable Declaration");
					System.exit(0);
			  	}
			   
				switch ($type.attr_type) {
					case INT:
						TextCode.add("istore " + storageIndex );
						break;
					case FLOAT:
						TextCode.add("fstore " + storageIndex );
						break;
					case DOUBLE:
						TextCode.add("f2d");
						TextCode.add("dstore " + storageIndex );
						break;
				}
			}

			switch ($type.attr_type) {
				case INT:
					storageIndex = storageIndex + 1;
					break;
				case FLOAT:
					storageIndex = storageIndex + 1;
					break;
				case DOUBLE:
					storageIndex = storageIndex + 2;
					break;
			}

		} 
		(',' c=Identifier 
		{
			if (symtab.containsKey($c.text)) {
				// variable re-declared.
		        System.out.println("Type Error: " + $c.getLine() + ": Redeclared identifier.");
		        System.exit(0);
		    }
		     
			/* Add ID and its attr_type into the symbol table. */
			ArrayList the_list = new ArrayList();
			the_list.add($type.attr_type);
			the_list.add(storageIndex);
		    symtab.put($c.text, the_list);
			//System.out.println($c.text+" "+storageIndex+" "+$type.attr_type);
		}
			('=' d=number
				{
					if($d.attr_type != null){

					   	if ($type.attr_type != $d.attr_type) {
							System.out.println("Type Error: Variable Declaration");
							System.exit(0);
					  	}
					   
						switch ($type.attr_type) {
							case INT:
								TextCode.add("istore " + storageIndex );
								break;
							case FLOAT:
								TextCode.add("fstore " + storageIndex );
								break;
							case DOUBLE:
								TextCode.add("f2d");
								TextCode.add("dstore " + storageIndex );
								break;
						}
					}

					
				}
			)?
			{
				switch ($type.attr_type) {
					case INT:
						storageIndex = storageIndex + 1;
						break;
					case FLOAT:
						storageIndex = storageIndex + 1;
						break;
					case DOUBLE:
						storageIndex = storageIndex + 2;
						break;
				}
			}
		)* 
		';' declarations
		{
			
		}
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

number	returns [Type attr_type]
		:
		Integer_constant	
		{ 
			$attr_type = Type.INT;
			
			// push the integer into the operand stack.
			TextCode.add("ldc " + $Integer_constant.text);
		}
		| Floating_point_constant
		{
			$attr_type = Type.FLOAT;
				
			TextCode.add("ldc " + $Floating_point_constant.text);
		}
		| Double_constant
		{
			$attr_type = Type.DOUBLE;
				
			TextCode.add("ldc " + $Double_constant.text.replaceAll("d", ""));
		}
		| BIN_NUM
		| HEX_NUM
		;

type returns [Type attr_type]
    	:
		SHORT		{ $attr_type=Type.SHORT; if (TRACEON) System.out.println("type: short"); }
		| INT		{ $attr_type=Type.INT; if (TRACEON) System.out.println("type: int"); }
		| LONG		{ $attr_type=Type.LONG; if (TRACEON) System.out.println("type: long"); }
		| FLOAT		{ $attr_type=Type.FLOAT; if (TRACEON) System.out.println("type: float"); }
		| DOUBLE	{ $attr_type=Type.DOUBLE; if (TRACEON) System.out.println("type: double"); }
		| CHAR		{ $attr_type=Type.CHAR; if (TRACEON) System.out.println("type: char"); }
		| BOOL		{ $attr_type=Type.BOOL; if (TRACEON) System.out.println("type: bool"); }
		| VOID		{ $attr_type=Type.VOID; if (TRACEON) System.out.println("type: void"); }
		| SIGNED	{ $attr_type=Type.SIGNED; if (TRACEON) System.out.println("type: signed"); }
		| UNSIGNED	{ $attr_type=Type.UNSIGNED; if (TRACEON) System.out.println("type: unsigned"); }
	;

statements
		:
		a=statement statements
        |
		;


arith_expression returns [Type attr_type]

		:
		a=multExpr
		{
			$attr_type = $a.attr_type;
		}
        ( '+' b=multExpr
		{
			if ($attr_type != $b.attr_type) {
				System.out.println("Type Error: Addition");
				System.exit(0);
		  	}
			if ( ($attr_type == Type.INT) && ($b.attr_type == Type.INT) )
				TextCode.add("iadd");
			else if ( ($attr_type == Type.FLOAT) && ($b.attr_type == Type.FLOAT) )
				TextCode.add("fadd");
			else if ( ($attr_type == Type.DOUBLE) && ($b.attr_type == Type.DOUBLE) )
				TextCode.add("dadd");

			if (TRACEON) System.out.println("operation: addition");
		}
		| '-' c=multExpr
		{
			if ($attr_type != $c.attr_type) {
				System.out.println("Type Error: Subtraction");
				System.exit(0);
		  	}
			if ( ($attr_type == Type.INT) && ($c.attr_type == Type.INT) )
				TextCode.add("isub");
			else if ( ($attr_type == Type.FLOAT) && ($c.attr_type == Type.FLOAT) )
				TextCode.add("fsub");
			else if ( ($attr_type == Type.DOUBLE) && ($c.attr_type == Type.DOUBLE) )
				TextCode.add("dsub");
			
			if (TRACEON) System.out.println("operation: subtract");
		}
		)*
        ;

multExpr returns [Type attr_type]
		: 
		a=signExpr
		{
			$attr_type = $a.attr_type;
		}
        ( '*' b=signExpr
		{
			if ($attr_type != $b.attr_type) {
				System.out.println("Type Error: Multiply");
				System.exit(0);
		  	}
			if ( ($attr_type == Type.INT) && ($b.attr_type == Type.INT) )
				TextCode.add("imul");
			else if ( ($attr_type == Type.FLOAT) && ($b.attr_type == Type.FLOAT) )
				TextCode.add("fmul");
			else if ( ($attr_type == Type.DOUBLE) && ($b.attr_type == Type.DOUBLE) )
				TextCode.add("dmul");
			
			if (TRACEON) System.out.println("operation: multiply");
		}
        | '/' c=signExpr
		{
			if ($attr_type != $c.attr_type) {
				System.out.println("Type Error: Division");
				System.exit(0);
		  	}
			if ( ($attr_type == Type.INT) && ($c.attr_type == Type.INT) )
				TextCode.add("idiv");
			else if ( ($attr_type == Type.FLOAT) && ($c.attr_type == Type.FLOAT) )
				TextCode.add("fdiv");
			else if ( ($attr_type == Type.DOUBLE) && ($c.attr_type == Type.DOUBLE) )
				TextCode.add("ddiv");

			if (TRACEON) System.out.println("operation: division");
		}
		| '%' d=signExpr
		{
			if ($attr_type != $d.attr_type) {
				System.out.println("Type Error: Mod");
				System.exit(0);
		  	}
			if ( ($attr_type == Type.INT) && ($d.attr_type == Type.INT) )
				TextCode.add("irem");
			else if ( ($attr_type == Type.FLOAT) && ($d.attr_type == Type.FLOAT) )
				TextCode.add("frem");
			else if ( ($attr_type == Type.DOUBLE) && ($d.attr_type == Type.DOUBLE) )
				TextCode.add("drem");

			if (TRACEON) System.out.println("operation: mod");
		}
		)*
		;

signExpr returns [Type attr_type]
		: 
		a=primaryExpr
		{ 
			$attr_type = $a.attr_type;
		}
		| ('++')=> '++' b=Identifier
		{ 
			$attr_type = (Type) symtab.get($Identifier.text).get(0);
			
			switch ($attr_type) {
				case INT: 
			        // load the variable into the operand stack.
			        TextCode.add("iload " + symtab.get($Identifier.text).get(1));
					TextCode.add("ldc 1");
					TextCode.add("iadd");
					TextCode.add("istore " + symtab.get($Identifier.text).get(1));
					//TextCode.add("iload " + symtab.get($Identifier.text).get(1));
			 	    break;
				case FLOAT: 
			        // load the variable into the operand stack.
			        TextCode.add("fload " + symtab.get($Identifier.text).get(1));
					TextCode.add("ldc 1.0");
					TextCode.add("fadd");
					TextCode.add("fstore " + symtab.get($Identifier.text).get(1));
					//TextCode.add("fload " + symtab.get($Identifier.text).get(1));
			 	    break;
				case DOUBLE: 
			        // load the variable into the operand stack.
			        TextCode.add("dload " + symtab.get($Identifier.text).get(1));
					TextCode.add("ldc 1.0");
					TextCode.add("f2d");
					TextCode.add("dadd");
					TextCode.add("dstore " + symtab.get($Identifier.text).get(1));
					//TextCode.add("dload " + symtab.get($Identifier.text).get(1));
			 	    break;
			}
			if (TRACEON) System.out.println("primaryExpr: ++id"); 
		}
    	| ('--')=> '--' c=Identifier
		{	
			$attr_type = (Type) symtab.get($Identifier.text).get(0);
			
			switch ($attr_type) {
				case INT: 
			        // load the variable into the operand stack.
			        TextCode.add("iload " + symtab.get($Identifier.text).get(1));
					TextCode.add("ldc 1");
					TextCode.add("isub");
					TextCode.add("istore " + symtab.get($Identifier.text).get(1));
					//TextCode.add("iload " + symtab.get($Identifier.text).get(1));
			 	    break;
				case FLOAT: 
			        // load the variable into the operand stack.
			        TextCode.add("fload " + symtab.get($Identifier.text).get(1));
					TextCode.add("ldc 1.0");
					TextCode.add("fsub");
					TextCode.add("fstore " + symtab.get($Identifier.text).get(1));
					//TextCode.add("fload " + symtab.get($Identifier.text).get(1));
			 	    break;
				case DOUBLE: 
			        // load the variable into the operand stack.
			        TextCode.add("dload " + symtab.get($Identifier.text).get(1));
					TextCode.add("ldc 1.0");
					TextCode.add("f2d");
					TextCode.add("dsub");
					TextCode.add("dstore " + symtab.get($Identifier.text).get(1));
					//TextCode.add("dload " + symtab.get($Identifier.text).get(1));
			 	    break;
			}
			if (TRACEON) System.out.println("primaryExpr: --id");
		}
		| ('-') => ('-') d=Identifier
		{
			$attr_type = (Type) symtab.get($Identifier.text).get(0);
			
			switch ($attr_type) {
				case INT: 
			        // load the variable into the operand stack.
			        TextCode.add("iload " + symtab.get($Identifier.text).get(1));
					TextCode.add("ineg");
			 	    break;
				case FLOAT: 
			        // load the variable into the operand stack.
			        TextCode.add("fload " + symtab.get($Identifier.text).get(1));
					TextCode.add("fneg");
			 	    break;
				case DOUBLE: 
			        // load the variable into the operand stack.
			        TextCode.add("dload " + symtab.get($Identifier.text).get(1));
					TextCode.add("dneg");
			 	    break;
			}
				
			if (TRACEON) System.out.println("signExpr"); 
		}
		| ('!') => '!' e=Identifier							{ if (TRACEON) System.out.println("primaryExpr: !"); } 
		| ('~') => '~' f=Identifier
		{ 
			if (TRACEON) System.out.println("primaryExpr: ~"); 
		}		
		;
		  
primaryExpr returns [Type attr_type] 
@init{
	int optype = 0;
}		
		: 
		Integer_constant	
		{ 
			$attr_type = Type.INT;
			
			// push the integer into the operand stack.
			TextCode.add("ldc " + $Integer_constant.text);
		}
        | Floating_point_constant
		{ 
			$attr_type = Type.FLOAT;
			
			TextCode.add("ldc " + $Floating_point_constant.text);
		}
		| Double_constant
		{
			$attr_type = Type.DOUBLE;
				
			TextCode.add("ldc " + $Double_constant.text.replaceAll("d", ""));
			TextCode.add("f2d");
		}
        | Identifier
		{
		    $attr_type = (Type) symtab.get($Identifier.text).get(0);
			
			switch ($attr_type) {
				case INT: 
			          // load the variable into the operand stack.
			          TextCode.add("iload " + symtab.get($Identifier.text).get(1));
			 	      break;
				case FLOAT: 
			          // load the variable into the operand stack.
			          TextCode.add("fload " + symtab.get($Identifier.text).get(1));
			 	      break;
				case DOUBLE: 
			          // load the variable into the operand stack.
			          TextCode.add("dload " + symtab.get($Identifier.text).get(1));
			 	      break;
			}

		}
		| Identifier ('++' { optype = 1; if (TRACEON) System.out.println("primaryExpr: id++"); } | '--' { optype = 2; if (TRACEON) System.out.println("primaryExpr: id--"); })
		{
			if(optype == 1){
				$attr_type = (Type) symtab.get($Identifier.text).get(0);
				
				switch ($attr_type) {
					case INT: 
					    // load the variable into the operand stack.
					    TextCode.add("iload " + symtab.get($Identifier.text).get(1));
						//TextCode.add("dup");
						TextCode.add("ldc 1");
						TextCode.add("iadd");
						TextCode.add("istore " + symtab.get($Identifier.text).get(1));
				 	    break;
					case FLOAT: 
					    // load the variable into the operand stack.
					    TextCode.add("fload " + symtab.get($Identifier.text).get(1));
						//TextCode.add("dup");
						TextCode.add("ldc 1.0");
						TextCode.add("fadd");
						TextCode.add("fstore " + symtab.get($Identifier.text).get(1));
				 	    break;
					case DOUBLE: 
					    // load the variable into the operand stack.
					    TextCode.add("dload " + symtab.get($Identifier.text).get(1));
						//TextCode.add("dup");
						TextCode.add("ldc 1.0");
						TextCode.add("f2d");
						TextCode.add("dadd");
						TextCode.add("dstore " + symtab.get($Identifier.text).get(1));
				 	    break;
				}
			}
			else if(optype == 2){
				$attr_type = (Type) symtab.get($Identifier.text).get(0);
				
				switch ($attr_type) {
					case INT: 
					    // load the variable into the operand stack.
					    TextCode.add("iload " + symtab.get($Identifier.text).get(1));
						//TextCode.add("dup");
						TextCode.add("ldc 1");
						TextCode.add("isub");
						TextCode.add("istore " + symtab.get($Identifier.text).get(1));
				 	    break;
					case FLOAT: 
					    // load the variable into the operand stack.
					    TextCode.add("fload " + symtab.get($Identifier.text).get(1));
						//TextCode.add("dup");
						TextCode.add("ldc 1.0");
						TextCode.add("fsub");
						TextCode.add("fstore " + symtab.get($Identifier.text).get(1));
				 	    break;
					case DOUBLE: 
					    // load the variable into the operand stack.
					    TextCode.add("dload " + symtab.get($Identifier.text).get(1));
						//TextCode.add("dup");
						TextCode.add("ldc 1.0");
						TextCode.add("f2d");
						TextCode.add("dsub");
						TextCode.add("dstore " + symtab.get($Identifier.text).get(1));
				 	    break;
				}
			}
		}			
		| '(' conditional[-1] ')'
		{
			$attr_type = $conditional.attr_type;
		}
		//| Identifier '[' Integer_constant ']'		{ if (TRACEON) System.out.println("primaryExpr: []"); }
        ;

expression[int count]
    	:
		a=assignment[count]
		{

		}
		(',' assignment[count] )*
    	;

assignment[int count] returns [Type attr_type]
    	: 
		Identifier operator a=assignment[-1]
		{
			Type the_type;
		 	int the_mem;
		   
		 	// get the ID's location and type from symtab.			   
		   	the_type = (Type) symtab.get($Identifier.text).get(0);
		   	the_mem = (int) symtab.get($Identifier.text).get(1);
		   
		   	if (the_type != $a.attr_type) {
		    	System.out.println("Type error: Assignment");
				System.exit(0);
		  	}
		   
			switch($operator.op){
				case 1:		// =
					switch (the_type) {
						case INT:
							TextCode.add("istore " + the_mem);
				        	break;
						case FLOAT:
							TextCode.add("fstore " + the_mem);
				        	break;
						case DOUBLE:
							TextCode.add("dstore " + the_mem);
				        	break;
			   		}
					break;
				case 2:		// +=
					switch (the_type) {
						case INT:
							TextCode.add("iload " + symtab.get($Identifier.text).get(1));
							TextCode.add("swap");
							TextCode.add("iadd");
							TextCode.add("istore " + the_mem);
				        	break;
						case FLOAT:
							TextCode.add("fload " + symtab.get($Identifier.text).get(1));
							TextCode.add("swap");
							TextCode.add("fadd");
							TextCode.add("fstore " + the_mem);
				        	break;
						case DOUBLE:
							TextCode.add("dload " + symtab.get($Identifier.text).get(1));
							TextCode.add("dadd");
							TextCode.add("dstore " + the_mem);
				        	break;
			   		}
					break;
				case 3:		// -=
					switch (the_type) {
						case INT:
							TextCode.add("iload " + symtab.get($Identifier.text).get(1));
							TextCode.add("swap");
							TextCode.add("isub");
							TextCode.add("istore " + the_mem);
				        	break;
						case FLOAT:
							TextCode.add("fload " + symtab.get($Identifier.text).get(1));
							TextCode.add("swap");
							TextCode.add("fsub");
							TextCode.add("fstore " + the_mem);
				        	break;
						case DOUBLE:
							TextCode.add("dload " + symtab.get($Identifier.text).get(1));
							TextCode.add("dsub");
							TextCode.add("dneg");
							TextCode.add("dstore " + the_mem);
				        	break;
			   		}
					break;
				case 4:		// *=
					switch (the_type) {
						case INT:
							TextCode.add("iload " + symtab.get($Identifier.text).get(1));
							TextCode.add("swap");
							TextCode.add("imul");
							TextCode.add("istore " + the_mem);
				        	break;
						case FLOAT:
							TextCode.add("fload " + symtab.get($Identifier.text).get(1));
							TextCode.add("swap");
							TextCode.add("fmul");
							TextCode.add("fstore " + the_mem);
				        	break;
						case DOUBLE:
							TextCode.add("dload " + symtab.get($Identifier.text).get(1));
							TextCode.add("dmul");
							TextCode.add("dstore " + the_mem);
				        	break;
			   		}
					break;
				case 5:		// /=
					switch (the_type) {
						case INT:
							TextCode.add("iload " + symtab.get($Identifier.text).get(1));
							TextCode.add("swap");
							TextCode.add("idiv");
							TextCode.add("istore " + the_mem);
				        	break;
						case FLOAT:
							TextCode.add("fload " + symtab.get($Identifier.text).get(1));
							TextCode.add("swap");
							TextCode.add("fdiv");
							TextCode.add("fstore " + the_mem);
				        	break;
						case DOUBLE:
							//TextCode.add("dload " + symtab.get($Identifier.text).get(1));
							//TextCode.add("swap");
							//TextCode.add("ddiv");
							//TextCode.add("dstore " + the_mem);
							System.out.println("Double: Not Support /=");
							System.exit(0);
				        	break;
			   		}
					break;
				case 6:		// \%=
					switch (the_type) {
						case INT:
							TextCode.add("iload " + symtab.get($Identifier.text).get(1));
							TextCode.add("swap");
							TextCode.add("irem");
							TextCode.add("istore " + the_mem);
				        	break;
						case FLOAT:
							TextCode.add("fload " + symtab.get($Identifier.text).get(1));
							TextCode.add("swap");
							TextCode.add("frem");
							TextCode.add("fstore " + the_mem);
				        	break;
						case DOUBLE:
							//TextCode.add("dload " + symtab.get($Identifier.text).get(1));
							//TextCode.add("swap");
							//TextCode.add("drem");
							//TextCode.add("dstore " + the_mem);
							System.out.println("Double: Not Support \%=");
							System.exit(0);
				        	break;
			   		}
					break;
				case 7:		// <<=
					switch (the_type) {
						case INT:
							TextCode.add("iload " + symtab.get($Identifier.text).get(1));
							TextCode.add("swap");
							TextCode.add("ishl");
							TextCode.add("istore " + the_mem);
				        	break;
						default:
							System.out.println("Type Error: <<=");
							System.exit(0);
							break;
			   		}
					break;
				case 8:		// >>=
					switch (the_type) {
						case INT:
							TextCode.add("iload " + symtab.get($Identifier.text).get(1));
							TextCode.add("swap");
							TextCode.add("ishr");
							TextCode.add("istore " + the_mem);
				        	break;
						default:
							System.out.println("Type Error: >>=");
							System.exit(0);
							break;
			   		}
					break;
				case 9:		// &=
					switch (the_type) {
						case INT:
							TextCode.add("iload " + symtab.get($Identifier.text).get(1));
							TextCode.add("swap");
							TextCode.add("iand");
							TextCode.add("istore " + the_mem);
				        	break;
						default:
							System.out.println("Type Error: &=");
							System.exit(0);
							break;
			   		}
					break;
				case 10:	// |=
					switch (the_type) {
						case INT:
							TextCode.add("iload " + symtab.get($Identifier.text).get(1));
							TextCode.add("swap");
							TextCode.add("ior");
							TextCode.add("istore " + the_mem);
				        	break;
						default:
							System.out.println("Type Error: |=");
							System.exit(0);
							break;
			   		}
					break;
				case 11:	// ^=
					switch (the_type) {
						case INT:
							TextCode.add("iload " + symtab.get($Identifier.text).get(1));
							TextCode.add("swap");
							TextCode.add("ixor");
							TextCode.add("istore " + the_mem);
				        	break;
						default:
							System.out.println("Type Error: ^=");
							System.exit(0);
							break;
			   		}
					break;
			}
			   	
		}
    	| conditional[count]
		{
			$attr_type = $conditional.attr_type;
		}
    	;

conditional[int count] returns [Type attr_type]
@init{
	int first = 0;
	int second = 0;
}    	
		:
		a=or_or[count]
		{ 
			$attr_type = $a.attr_type;
		}
		('?' 
		{
			System.out.println("Error: Not Support ?: Operation");
			System.exit(0);
		}		
		assignment[-1] ':' assignment[-1] { if (TRACEON) System.out.println("relation: ? expression : conditional"); })?
    	;

or_or[int count] returns [Type attr_type]
    	:
		a=and_and[count]
		{ 
			$attr_type = $a.attr_type;
		}
		('||' b=and_and[count]
		{
			System.out.println("Error: Not Support || Operation");
			System.exit(0);

			if (TRACEON) System.out.println("relation: ||");
		}
		)*
    	;

and_and[int count] returns [Type attr_type]
    	:
		a=inclusive_or[count]
		{ 
			$attr_type = $a.attr_type;
		}
		('&&' b=inclusive_or[count]
		{
			System.out.println("Error: Not Support && Operation");
			System.exit(0);

			if (TRACEON) System.out.println("relation: &&");
		}
		)*
		{
			
		}
    	;

inclusive_or[int count] returns [Type attr_type]
    	:
		a=exclusive_or[count]
		{ 
			$attr_type = $a.attr_type;
		}
		('|' b=exclusive_or[count]
		{
			if ( ($attr_type != $b.attr_type) || ($attr_type != Type.INT) ) {
				System.out.println("Type Error: InclusiveOr");
				System.exit(0);
		  	}
			if ( ($attr_type == Type.INT) && ($b.attr_type == Type.INT) )
				TextCode.add("ior");
			else{
				System.out.println("Type Error: |");
				System.exit(0);		
			}

			if (TRACEON) System.out.println("relation: |");
		}
		)*
    	;

exclusive_or[int count] returns [Type attr_type]
    	:
		a=single_and[count]
		{ 
			$attr_type = $a.attr_type;
		}
		('^' b=single_and[count]
		{
			if ( ($attr_type != $b.attr_type) || ($attr_type != Type.INT) ) {
				System.out.println("Type Error: ExclusiveOr");
				System.exit(0);
		  	}
			if ( ($attr_type == Type.INT) && ($b.attr_type == Type.INT) )
				TextCode.add("ixor");
			else{
				System.out.println("Type Error: ^");
				System.exit(0);		
			}

			if (TRACEON) System.out.println("relation: ^");
		}
		)*
    	;

single_and[int count] returns [Type attr_type]
    	:
		a=equal[count]
		{ 
			$attr_type = $a.attr_type;
		}
		('&' b=equal[count]
		{
			if ( ($attr_type != $b.attr_type) || ($attr_type != Type.INT) ) {
				System.out.println("Type Error: SingleEnd");
				System.exit(0);
		  	}
			if ( ($attr_type == Type.INT) && ($b.attr_type == Type.INT) )
				TextCode.add("iand");
			else{
				System.out.println("Type Error: &");
				System.exit(0);		
			}

			if (TRACEON) System.out.println("relation: &");
		}
		)*
    	;

equal[int count] returns [Type attr_type]
@init{
	int optype = 0;
}
    	:
		a=relational[count]
		{ 
			$attr_type = $a.attr_type;
		}		
		(('==' { optype = 1; if (TRACEON) System.out.println("relation: =="); } 
		| '!=' { optype = 2; if (TRACEON) System.out.println("relation: !="); } ) b=relational[count]
		{
			if ( $attr_type != $b.attr_type ) {
				System.out.println("Type Error: Equality");
				System.exit(0);
		  	}
			if(optype == 1){
				if ( ($attr_type == Type.INT) && ($b.attr_type == Type.INT) ){
					TextCode.add("if_icmpne ELSE" + count);
				}
				else if ( ($attr_type == Type.FLOAT) && ($b.attr_type == Type.FLOAT) ){
					TextCode.add("fcmpl");
					TextCode.add("ifne ELSE" + count);
				}
				else if ( ($attr_type == Type.DOUBLE) && ($b.attr_type == Type.DOUBLE) ){
					TextCode.add("dcmpl");
					TextCode.add("ifne ELSE" + count);
				}
			}
			else if(optype == 2){
				if ( ($attr_type == Type.INT) && ($b.attr_type == Type.INT) ){
					TextCode.add("if_icmpeq ELSE" + count);
				}
				else if ( ($attr_type == Type.FLOAT) && ($b.attr_type == Type.FLOAT) ){
					TextCode.add("fcmpl");
					TextCode.add("ifeq ELSE" + count);
				}
				else if ( ($attr_type == Type.DOUBLE) && ($b.attr_type == Type.DOUBLE) ){
					TextCode.add("dcmpl");
					TextCode.add("ifeq ELSE" + count);
				}
			}
		} 
		)*
    	;

relational[int count] returns [Type attr_type]
@init{
	int optype = 0;
}		
		:
		a=shift[count]
		{ 
			$attr_type = $a.attr_type;
		}	
		(
		( 
		  '<=' { optype = 3; if (TRACEON) System.out.println("relation: <="); } 
		| '>=' { optype = 4; if (TRACEON) System.out.println("relation: >="); }
		| '<' { optype = 1; if (TRACEON) System.out.println("relation: <"); } 
		| '>' { optype = 2; if (TRACEON) System.out.println("relation: >"); } ) b=shift[count]
		{
			if ( $attr_type != $b.attr_type ) {
				System.out.println("Type Error: Relational");
				System.exit(0);
		  	}
			if(optype == 1){
				if ( ($attr_type == Type.INT) && ($b.attr_type == Type.INT) ){
					TextCode.add("if_icmpge ELSE" + count);
				}
				else if ( ($attr_type == Type.FLOAT) && ($b.attr_type == Type.FLOAT) ){
					TextCode.add("fcmpl");
					TextCode.add("ifge ELSE" + count);
				}
				else if ( ($attr_type == Type.DOUBLE) && ($b.attr_type == Type.DOUBLE) ){
					TextCode.add("dcmpl");
					TextCode.add("ifge ELSE" + count);
				}
			}
			else if(optype == 2){
				if ( ($attr_type == Type.INT) && ($b.attr_type == Type.INT) ){
					TextCode.add("if_icmple ELSE" + count);
				}
				else if ( ($attr_type == Type.FLOAT) && ($b.attr_type == Type.FLOAT) ){
					TextCode.add("fcmpl");
					TextCode.add("ifle ELSE" + count);
				}
				else if ( ($attr_type == Type.DOUBLE) && ($b.attr_type == Type.DOUBLE) ){
					TextCode.add("dcmpl");
					TextCode.add("ifle ELSE" + count);
				}
			}
			else if(optype == 3){
				if ( ($attr_type == Type.INT) && ($b.attr_type == Type.INT) ){
					TextCode.add("if_icmpgt ELSE" + count);
				}
				else if ( ($attr_type == Type.FLOAT) && ($b.attr_type == Type.FLOAT) ){
					TextCode.add("fcmpl");
					TextCode.add("ifgt ELSE" + count);
				}
				else if ( ($attr_type == Type.DOUBLE) && ($b.attr_type == Type.DOUBLE) ){
					TextCode.add("dcmpl");
					TextCode.add("ifgt ELSE" + count);
				}
			}
			else if(optype == 4){
				if ( ($attr_type == Type.INT) && ($b.attr_type == Type.INT) ){
					TextCode.add("if_icmplt ELSE" + count);
				}
				else if ( ($attr_type == Type.FLOAT) && ($b.attr_type == Type.FLOAT) ){
					TextCode.add("fcmpl");
					TextCode.add("iflt ELSE" + count);
				}
				else if ( ($attr_type == Type.DOUBLE) && ($b.attr_type == Type.DOUBLE) ){
					TextCode.add("dcmpl");
					TextCode.add("iflt ELSE" + count);
				}
			}
		} 		
		)*
    	;

shift[int count] returns [Type attr_type]
@init{
	int optype = 0;
}    	
		: 
		a=arith_expression
		{ 
			$attr_type = $a.attr_type;
		}
		(('<<' { optype = 1; if (TRACEON) System.out.println("relation: <<"); } 
		| '>>' { optype = 2; if (TRACEON) System.out.println("relation: >>"); } ) b=arith_expression
		{
			if ( $attr_type != $b.attr_type ) {
				System.out.println("Type Error: Shift");
				System.exit(0);
		  	}
			if(optype == 1){
				if ( ($attr_type == Type.INT) && ($b.attr_type == Type.INT) )
					TextCode.add("ishl");
				else{
					System.out.println("Type Error: <<");
					System.exit(0);		
				}
			}
			else if(optype == 2){
				if ( ($attr_type == Type.INT) && ($b.attr_type == Type.INT) )
					TextCode.add("ishr");
				else{
					System.out.println("Type Error: >>");
					System.exit(0);		
				}
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

statement
@init{
	String literal = "";
	int switchDefault = 0;
	int forFrom = 0;

	int count = 0;
	int countEnd = 0;
}
		: 
		expression[-1]  ';'
        | 	IF 
			{
				count = elseCount;
				elseCount++;
				countEnd = endCount;
				endCount++;
			}
			'(' a=expression[count] ')' 
			then_statements
			{
				TextCode.add("goto END" + countEnd);
				TextCode.add("ELSE" + count + ":");
				if (TRACEON) System.out.println("end of if");
			}

			( (ELSE IF)=> ELSE IF 	{ count = elseCount;	elseCount++; }
			'(' b=expression[count] ')' 
			then_statements
			{ 
				TextCode.add("goto END" + countEnd);
				TextCode.add("ELSE" + count + ":");
				if (TRACEON) System.out.println("end of else if");
			}
			)*

			( (ELSE)=> ELSE then_statements { if (TRACEON) System.out.println("end of else"); } )?
			{
				TextCode.add("END" + countEnd + ":");
			}		
			
		|   SWITCH 		{ countEnd = endCount;	endCount++;	switchDefault = 0;}
		'(' a=expression[-1] ')' { TextCode.add("lookupswitch"); switchIndex = TextCode.size(); switchDefault = 0;}
		'{' ( switch_statements[countEnd] )*
		(   DEFAULT ':' 
		{
			TextCode.add(switchIndex, "default : R" + caseCount);
			++switchIndex;
			TextCode.add("R" + caseCount + ":");
			++caseCount;

			switchDefault = 1;
		}
		statements (BREAK ';')? )? '}'
		{
			if(switchDefault == 0){
				TextCode.add(switchIndex, "default : R" + caseCount);
				++switchIndex;
				TextCode.add("R" + caseCount + ":");
				++caseCount;
			}

			TextCode.add("END" + countEnd + ":");
			if (TRACEON) System.out.println("end of switch"); 
		}
		
		|   WHILE 	
		{
			countEnd = loopCount;
			loopCount++; 
			TextCode.add("Loop" + countEnd + ":");

			count = elseCount;
			elseCount++;
		}
		'(' expression[count] ')' 
		then_statements
		{
			TextCode.add("goto Loop" + countEnd);
			TextCode.add("ELSE" + count + ":");
		}													

		{ if (TRACEON) System.out.println("end of while"); }

    	|   DO 		
		{ 
			countEnd = loopCount;
			loopCount++; 
			TextCode.add("Loop" + countEnd + ":");
		
			count = elseCount;
			elseCount++;
		}
		then_statements WHILE '(' expression[count] ')' ';'												
		{
			TextCode.add("goto Loop" + countEnd);
			TextCode.add("ELSE" + count + ":");
		}	

		{ if (TRACEON) System.out.println("end of do while"); }

    	|   FOR 
		{
			countEnd = loopCount;
			loopCount++; 
			count = elseCount;
			elseCount++;
		}
		'(' expression[-1]? ';' 	{ TextCode.add("Loop" + countEnd + ":");}
		expression[count]? ';' 		{ forFrom = TextCode.size(); }
		expression[-1]? ')' 		
		{
			TextCodeCopy = new ArrayList<String>(TextCode);
			TextCodeCopy = TextCodeCopy.subList(forFrom, TextCode.size());

			TextCode.subList(forFrom, TextCode.size()).clear();
		}
		then_statements				
		{
			TextCode.addAll(TextCodeCopy);

			TextCode.add("goto Loop" + countEnd);
			TextCode.add("ELSE" + count + ":");
		}	
		{ if (TRACEON) System.out.println("end of for"); }
		 
    	|   CONTINUE ';'																						
		{
			TextCode.add("goto Loop" + (loopCount-1) );
		}
		{ if (TRACEON) System.out.println("continue"); }

    	//| BREAK ';'
		{
			//TextCode.add("goto ELSE" + (endCount-1) );
		}
    	| RETURN expression[-1]? ';'
		//| RETURN Integer_constant? ';'
		{
		}
		{ if (TRACEON) System.out.println("return"); }

		|   'goto' Identifier ';'																				
		{
			TextCode.add("goto " + $Identifier.text);
		}
		{ if (TRACEON) System.out.println("goto"); }

 		|   Identifier ':' 																
		{
			TextCode.add( $Identifier.text + ":");
		}
		statement	
		{ if (TRACEON) System.out.println("goto anchor"); }

		|   PRINTF 
			'(' Literal1
			{ 
				TextCode.add("getstatic java/lang/System/out Ljava/io/PrintStream;");
				literal = $Literal1.text; 
				literal = literal.replaceAll("\"", ""); 
			} 
			(',' io_then_statement 	
			{ 
				
				String output = literal.substring(0, literal.indexOf('\%'));
				TextCode.add("ldc \"" + output + "\"");
				TextCode.add("invokevirtual java/io/PrintStream/print(Ljava/lang/String;)V");
				TextCode.add("getstatic java/lang/System/out Ljava/io/PrintStream;");

				switch( literal.charAt(literal.indexOf('\%') + 1) ){
					case 'd':
						literal = literal.substring(literal.indexOf('\%') + 2);
						TextCode.add("iload " + $io_then_statement.position);
						TextCode.add("invokevirtual java/io/PrintStream/print(I)V");
						TextCode.add("getstatic java/lang/System/out Ljava/io/PrintStream;");
						break;
					case 'f':
						literal = literal.substring(literal.indexOf('\%') + 2);
						TextCode.add("fload " + $io_then_statement.position);
						TextCode.add("invokevirtual java/io/PrintStream/print(F)V");
						TextCode.add("getstatic java/lang/System/out Ljava/io/PrintStream;");
						break;
					case 'l':
						if( literal.charAt(literal.indexOf('\%') + 2) != 'f' )		break;
						literal = literal.substring(literal.indexOf('\%') + 3);
						TextCode.add("dload " + $io_then_statement.position);
						TextCode.add("invokevirtual java/io/PrintStream/print(D)V");
						TextCode.add("getstatic java/lang/System/out Ljava/io/PrintStream;");
						break;
				}
			} 
			)* 
			')' ';'
			{
				TextCode.add("ldc \"" + literal + "\"");
   				TextCode.add("invokevirtual java/io/PrintStream/print(Ljava/lang/String;)V"); 

				if (TRACEON) System.out.println("printf"); 
			}

		|   SCANF 
			'(' Literal1
			{ 
				literal = $Literal1.text; 
				literal = literal.replaceAll("\"", "");
			} 
			(',''&' scanf_statment  	
			{
				TextCode.add("new java/util/Scanner");
				TextCode.add("dup");
				TextCode.add("getstatic java/lang/System/in Ljava/io/InputStream;");
				TextCode.add("invokespecial java/util/Scanner/<init>(Ljava/io/InputStream;)V");

				switch( literal.charAt(literal.indexOf('\%') + 1) ){
					case 'd':
						TextCode.add("invokevirtual java/util/Scanner/nextInt()I");
						TextCode.add("istore " + $scanf_statment.position);
						literal = literal.substring(literal.indexOf('\%') + 2);
						break;
					case 'f':
						TextCode.add("invokevirtual java/util/Scanner/nextFloat()F");
						TextCode.add("fstore " + $scanf_statment.position);
						literal = literal.substring(literal.indexOf('\%') + 2);
						break;
					case 'l':
						if( literal.charAt(literal.indexOf('\%') + 2) != 'f' )		break;
						TextCode.add("invokevirtual java/util/Scanner/nextDouble()D");
						TextCode.add("dstore " + $scanf_statment.position);
						literal = literal.substring(literal.indexOf('\%') + 3);
						break;
					default:
						System.out.println("ERROR: (scanf) invaild or unsupport type");
						System.exit(0);
				}
				
			} 
			)*
			')' ';'
			{
				if (TRACEON) System.out.println("scanf");
			}
		|   type Identifier '(' expression[-1]? ')' '{' declarations statements '}'								{ if (TRACEON) System.out.println("end of function"); }
		|   ';'
		//| (type Identifier) => type Identifier ('=' b=number)?
		;

switch_statements[int countEnd]
@init{
	int flag = 0;
}		
		:
		//CASE a=conditional ':' 
		CASE Integer_constant ':'
		{
			TextCode.add(switchIndex, $Integer_constant.text + ": R" + caseCount);
			++switchIndex;
			TextCode.add("R" + caseCount + ":");
			++caseCount;
		}
		statements 
		BREAK ';'														{ if (TRACEON) System.out.println("case"); }
		{
			TextCode.add("goto END" + countEnd);
		}
    	;

then_statements
		:
		a=statement
        | '{' b=statements '}'
		;

scanf_statment returns [int position]
		:
		Identifier
		{
			$position = (int) symtab.get($Identifier.text).get(1);
		}
		;

io_then_statement returns [int position]
@init{
	int optype = 0;
}
		:
		//conditional
		Identifier
		{
			$position = (int) symtab.get($Identifier.text).get(1);
		}
		//| SIZEOF '(' (a=Identifier { optype = 1; } | b=type { optype = 2; } ) ')'
		//{ 
			//if (TRACEON) System.out.println("sizeof"); 
		//}
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
Double_constant:'0'..'9'+ '.' '0'..'9'+'d';
BIN_NUM : '0'('b' | 'B')('0' | '1')+;
HEX_NUM : '0'('x' | 'X')('0'..'9' | 'a'..'f' | 'A'..'F')+;

Escape : '\\';
COMMENT:'/*' .* '*/' {$channel=HIDDEN;};
COMMENT2:'//' .* '\n' {$channel=HIDDEN;};
Literal1 : '"'(options{greedy=false;}: .)*'"';
Literal2 : '\''(options{greedy=false;}: .)*'\'';
INPORT: '#' .* '\n' {$channel=HIDDEN;};
WS:( ' ' | '\t' | '\r' | '\n' ) {$channel=HIDDEN;};

