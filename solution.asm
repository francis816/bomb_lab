
0000000000400ee0 <phase_1>:
  400ee0:	48 83 ec 08          	sub    $0x8,%rsp                  // allocate 8 bytes on stack
  400ee4:	be 00 24 40 00       	mov    $0x402400,%esi             // move a string at 0x402400 to 2nd param
  400ee9:	e8 4a 04 00 00       	call   401338 <strings_not_equal> // compare 1st param (our input) to 2nd param
  400eee:	85 c0                	test   %eax,%eax                  
  400ef0:	74 05                	je     400ef7 <phase_1+0x17>      // if return value = 0 (equal) jump
                                                                          // return value = 1 means true for 
									  // strings_ not_ equal

  400ef2:	e8 43 05 00 00       	call   40143a <explode_bomb>      // otherwise explode the bomb
  400ef7:	48 83 c4 08          	add    $0x8,%rsp                  // deallocate 8 bytes on stack
  400efb:	c3                   	ret    

/*
so we can just x/s 0x402400 to see what the answer string is 

*/






0000000000400efc <phase_2>:
  400efc:	55                   	push   %rbp                       // push original caller value to stack so we can use %rbp register
  400efd:	53                   	push   %rbx                       // same as %rbc
  400efe:	48 83 ec 28          	sub    $0x28,%rsp                 // allocate 40 bytes on stack
  400f02:	48 89 e6             	mov    %rsp,%rsi                  // copy stack top pointer to 2nd param
  400f05:	e8 52 05 00 00       	call   40145c <read_six_numbers>  // load 6 numbers
  400f0a:	83 3c 24 01          	cmpl   $0x1,(%rsp)                // compare 1 to value at stack top
  400f0e:	74 20                	je     400f30 <phase_2+0x34>      // equal = jump
  400f10:	e8 25 05 00 00       	call   40143a <explode_bomb>      // not equal = bomb, so must = 1
  400f15:	eb 19                	jmp    400f30 <phase_2+0x34> 

  400f17:	8b 43 fc             	mov    -0x4(%rbx),%eax            // move the val before rbx to eax
                                                                          // we can see each val is 4 byte, so = int
									  // a bit like i - 1 
  400f1a:	01 c0                	add    %eax,%eax                  // x2 on the value
  400f1c:	39 03                	cmp    %eax,(%rbx)                // compare value at eax and rbx
  400f1e:	74 05                	je     400f25 <phase_2+0x29>      // equal, jump
  400f20:	e8 15 05 00 00       	call   40143a <explode_bomb>      // not equal, bomb
                                                                          // so we can see i = (i - 1) * 2

  400f25:	48 83 c3 04          	add    $0x4,%rbx                  // increment
  400f29:	48 39 eb             	cmp    %rbp,%rbx                  // see if i reaches the end yet
  400f2c:	75 e9                	jne    400f17 <phase_2+0x1b>      // if not, continue looping
  400f2e:	eb 0c                	jmp    400f3c <phase_2+0x40>      // if yes, finish the loop
  400f30:	48 8d 5c 24 04       	lea    0x4(%rsp),%rbx             // stack top pointer + 4 bytes to rbx
  400f35:	48 8d 6c 24 18       	lea    0x18(%rsp),%rbp            // stack top pointer + 24 bytes to rbp
                                                                          // we can see we are initailizing vals
			                                                  // for potential loop
														
  400f3a:	eb db                	jmp    400f17 <phase_2+0x1b>      
  400f3c:	48 83 c4 28          	add    $0x28,%rsp                 // deallocate the stack
  400f40:	5b                   	pop    %rbx                       // pop back the value in memory stack back to the registers
  400f41:	5d                   	pop    %rbp
  400f42:	c3                   	ret    






0000000000400f43 <phase_3>:
  400f43:	48 83 ec 18          	sub    $0x18,%rsp                   // allocate 24 bytes to stack
  400f47:	48 8d 4c 24 0c       	lea    0xc(%rsp),%rcx               // set 4th param as stack top + 12 pointer
  400f4c:	48 8d 54 24 08       	lea    0x8(%rsp),%rdx               // set 3rd param as stack top + 8 pointer
  400f51:	be cf 25 40 00       	mov    $0x4025cf,%esi               // move the val at 0x4025cf to 2nd param
                                                                            // we can x/s 0x4025cf to see what the string (aka string format here) is
  400f56:	b8 00 00 00 00       	mov    $0x0,%eax                    // clear eax

  400f5b:	e8 90 fc ff ff       	call   400bf0 <__isoc99_sscanf@plt> // call c function sscanf
                                                                            // for sscanf:
								            // 1st param = input string
									    // 2nd param = string format e.g. "%d %d"
									    // 3rd param = 1st %d
									    // 4th param = 2nd %d
									    // return value = total in the string
									    // e.g. "%d is %d and %lf" = 3 

  400f60:	83 f8 01             	cmp    $0x1,%eax                    // compare 1 to return value
  400f63:	7f 05                	jg     400f6a <phase_3+0x27>        // jump if more than 1 
  400f65:	e8 d0 04 00 00       	call   40143a <explode_bomb>        // or bomb
  400f6a:	83 7c 24 08 07       	cmpl   $0x7,0x8(%rsp)               // compare 7 to value at stack top + 8
  400f6f:	77 3c                	ja     400fad <phase_3+0x6a>        // if above, jump and bomb, so <= 7
  400f71:	8b 44 24 08          	mov    0x8(%rsp),%eax               // move 3rd param to the result register
  400f75:	ff 24 c5 70 24 40 00 	jmp    *0x402470(,%rax,8)           // jump to a location depends on what you enter from 0 to 7

                                                                            // jump table below**

  400f7c:	b8 cf 00 00 00       	mov    $0xcf,%eax                   // if 3rd param = 0, move 207 to eax
  400f81:	eb 3b                	jmp    400fbe <phase_3+0x7b>
  400f83:	b8 c3 02 00 00       	mov    $0x2c3,%eax                  // if 3rd param = 2, move 707 to eax
  400f88:	eb 34                	jmp    400fbe <phase_3+0x7b>        
  400f8a:	b8 00 01 00 00       	mov    $0x100,%eax                  // not in consecutive order, so test number0 - 7 with gdb and see
  400f8f:	eb 2d                	jmp    400fbe <phase_3+0x7b>        
  400f91:	b8 85 01 00 00       	mov    $0x185,%eax
  400f96:	eb 26                	jmp    400fbe <phase_3+0x7b>
  400f98:	b8 ce 00 00 00       	mov    $0xce,%eax
  400f9d:	eb 1f                	jmp    400fbe <phase_3+0x7b>
  400f9f:	b8 aa 02 00 00       	mov    $0x2aa,%eax
  400fa4:	eb 18                	jmp    400fbe <phase_3+0x7b>
  400fa6:	b8 47 01 00 00       	mov    $0x147,%eax
  400fab:	eb 11                	jmp    400fbe <phase_3+0x7b>
  400fad:	e8 88 04 00 00       	call   40143a <explode_bomb>
  400fb2:	b8 00 00 00 00       	mov    $0x0,%eax                    
  400fb7:	eb 05                	jmp    400fbe <phase_3+0x7b>
  400fb9:	b8 37 01 00 00       	mov    $0x137,%eax                  // if 3rd param = 1, move 311 to eax
  400fbe:	3b 44 24 0c          	cmp    0xc(%rsp),%eax               // eventually we want 4th param to equal to eax, otherwise we bomb
  400fc2:	74 05                	je     400fc9 <phase_3+0x86>
  400fc4:	e8 71 04 00 00       	call   40143a <explode_bomb>
  400fc9:	48 83 c4 18          	add    $0x18,%rsp                   // deallocate stack
 400fcd:	c3                   	ret    

/* answer can be any of the 8 pairs above in the jump table
e.g. 0 207, 2 707 ... 
*/




0000000000400fce <func4>:
  400fce:	48 83 ec 08          	sub    $0x8,%rsp                    // allocate another 8 bytes below phase 4 stack frame
  400fd2:	89 d0                	mov    %edx,%eax                    // 14 into eax
  400fd4:	29 f0                	sub    %esi,%eax                    // 14 - 0
  400fd6:	89 c1                	mov    %eax,%ecx                    // 14 to ecx
  400fd8:	c1 e9 1f             	shr    $0x1f,%ecx                   // ecx = 14 >> 31 = 0
  400fdb:	01 c8                	add    %ecx,%eax                    // add 0 to 14 = 14
  400fdd:	d1 f8                	sar    %eax                         // 14 >> 1, aka 0000 1110 >> 1 = 0000 0111 = 7
  400fdf:	8d 0c 30             	lea    (%rax,%rsi,1),%ecx           // 0*1 + 7 to ecx
  400fe2:	39 f9                	cmp    %edi,%ecx                    // compare 1st param(aka 1st num) to 7
  400fe4:	7e 0c                	jle    400ff2 <func4+0x24>          // jump if <= 7
  400fe6:	8d 51 ff             	lea    -0x1(%rcx),%edx              // else 3rd param = 7 - 1 = 6
  400fe9:	e8 e0 ff ff ff       	call   400fce <func4>               //*** recursion(we skip first, not until the worse moment)
  400fee:	01 c0                	add    %eax,%eax          
  400ff0:	eb 15                	jmp    401007 <func4+0x39>
  400ff2:	b8 00 00 00 00       	mov    $0x0,%eax                    // eax = 0
  400ff7:	39 f9                	cmp    %edi,%ecx                    // compare if 1st param (also 1st num) = 7
  400ff9:	7d 0c                	jge    401007 <func4+0x39>          // if not, recursion, so we assume we do first
  400ffb:	8d 71 01             	lea    0x1(%rcx),%esi
  400ffe:	e8 cb ff ff ff       	call   400fce <func4>
  401003:	8d 44 00 01          	lea    0x1(%rax,%rax,1),%eax
  401007:	48 83 c4 08          	add    $0x8,%rsp                    // deallocate stack
  40100b:	c3                   	ret    

000000000040100c <phase_4>:
  40100c:	48 83 ec 18          	sub    $0x18,%rsp                  // allocate 24 bytes to stack
  401010:	48 8d 4c 24 0c       	lea    0xc(%rsp),%rcx              // again, stack top + 12 bytes pointer to 4th param
  401015:	48 8d 54 24 08       	lea    0x8(%rsp),%rdx              // stack + 8 pointer to 3rd param
  40101a:	be cf 25 40 00       	mov    $0x4025cf,%esi              // string format to 2nd param
  40101f:	b8 00 00 00 00       	mov    $0x0,%eax                   // reset result value
  401024:	e8 c7 fb ff ff       	call   400bf0 <__isoc99_sscanf@plt>// call string input function
  401029:	83 f8 02             	cmp    $0x2,%eax                   // we see must be 2 params in the string
  40102c:	75 07                	jne    401035 <phase_4+0x29>       // if != 2, jump and bomb
  40102e:	83 7c 24 08 0e       	cmpl   $0xe,0x8(%rsp)              // cmp 14 to 1st param val (1st num)
  401033:	76 05                	jbe    40103a <phase_4+0x2e>       // jump if <= 14
  401035:	e8 00 04 00 00       	call   40143a <explode_bomb>
                                                                           // params for func4**
  40103a:	ba 0e 00 00 00       	mov    $0xe,%edx                   // 3rd param = 14
  40103f:	be 00 00 00 00       	mov    $0x0,%esi                   // 2nd param = 0
  401044:	8b 7c 24 08          	mov    0x8(%rsp),%edi              // 1st param = 1st num (3rd for sscanf)
  401048:	e8 81 ff ff ff       	call   400fce <func4>              
  40104d:	85 c0                	test   %eax,%eax
  40104f:	75 07                	jne    401058 <phase_4+0x4c>       // see if eax from func4 = 0, not = bomb
  401051:	83 7c 24 0c 00       	cmpl   $0x0,0xc(%rsp)              // compare 0 to 2nd number
  401056:	74 05                	je     40105d <phase_4+0x51>       // if they are the same we finish
  401058:	e8 dd 03 00 00       	call   40143a <explode_bomb>
  40105d:	48 83 c4 18          	add    $0x18,%rsp                       
  401061:	c3                   	ret    


/*
we see that the 2nd number is 0 from the last couple instruction
and 1st number must <= 7. It can actually be a different number depends on how many recursion you run into.
7 = no recursion

so one of the answers is "7 0"
*/


0000000000401062 <phase_5>:


401062:   53                      push   %rbx                         // save original value in rbx into stack, so rbx is empty and can be used now 
401063:   48 83 ec 20             sub    $0x20,%rsp                   // allocate 32 bytes 
401067:   48 89 fb                mov    %rdi,%rbx                    // rbx = 1st param
40106a:   64 48 8b 04 25 28 00    mov    %fs:0x28,%rax                // get the canary value
401071:   00 00
401073:   48 89 44 24 18          mov    %rax,0x18(%rsp)              // save the canary value into stack top + 24th 
401078:   31 c0                   xor    %eax,%eax                    // reset eax to 0
40107a:   e8 9c 02 00 00          call   40131b <string_length>       
40107f:   83 f8 06                cmp    $0x6,%eax                    // see the length of 1st param
401082:   74 4e                   je     4010d2 <phase_5+0x70>        // eax = 6 so 1st param length = 6
401084:   e8 b1 03 00 00          call   40143a <explode_bomb>
401089:   eb 47                   jmp    4010d2 <phase_5+0x70>       
40108b:   0f b6 0c 03             movzbl (%rbx,%rax,1),%ecx           // use p *(char *)($rbx) to see what rbx is. And (at the beg.), you realize it is the array, aka the 1st element, and rax is the offset 
                                                                      // p *(char *)($rbx + 0x1) should be the 2nd element

40108f:   88 0c 24                mov    %cl,(%rsp)                   // we only move the lower byte of %ecx to stack top. lowerst byte is enough because a char is 1 byte
401092:   48 8b 14 24             mov    (%rsp),%rdx                  // move the lower byte value to rdx. rdx = 97
401096:   83 e2 0f                and    $0xf,%edx                    // mask rdx with 1111. e.g. 'a' = 97, 0110 0001 & 0000 1111, and we get 0000 0001. mask with 0xf means we only take the lower 4 bits. rdx = 1
                                                                      // 1st time: 1111 & 0110 0001 = >>>  1, aka 1, so we take 0x4024b0 + 1 => 'a'
                                                                      // 2nd time: 1111 & 0110 0010 = >>> 10, aka 2, so we take 0x4024b0 + 2 => 'a'
                                                                      // 3rd time: 1111 & 0110 0011 = >>> 11, aka 3, so 0x4024b0 + 3
                                                                      // 4th time: 1111 & 0110 0100 = >>> 100, aka 4, so 0x4024b4 
                                                                         
401099:   0f b6 92 b0 24 40 00    movzbl 0x4024b0(%rdx),%edx          // move the val at location (0x0001 + 0x4024b0) to %edx. using x/s 0x4024b1, we see that it is pointing at another 'a'
4010a0:   88 54 04 10             mov    %dl,0x10(%rsp,%rax,1)        // store 'a' at stack top + 16 bytes offset 
4010a4:   48 83 c0 01             add    $0x1,%rax                    // increment i by 1
4010a8:   48 83 f8 06             cmp    $0x6,%rax                    // continue looping until rax reaches 6
4010ac:   75 dd                   jne    40108b <phase_5+0x29>        // then you get "aduier"
4010ae:   c6 44 24 16 00          movb   $0x0,0x16(%rsp)              // at 21st offset from stack top = 'r' from above, set 22nd = 0, aka the end of string
4010b3:   be 5e 24 40 00          mov    $0x40245e,%esi               // x/s 0x40245e = "flyers" = esi
4010b8:   48 8d 7c 24 10          lea    0x10(%rsp),%rdi              // "aduier" = rdi
4010bd:   e8 76 02 00 00          call   401338 <strings_not_equal>   // if strings are """"not"""" equal, then return 1, aka if they are the same =  returns 0
                                                                      
					                              // *********** since "aduier" != "flyers", and "aduier" comes from our input of "abcdef"
								      // so we need to input 6 chars to make the string at 0x402450 to store "flyers" not "aduier"

4010c2:   85 c0                   test   %eax,%eax                 
4010c4:   74 13                   je     4010d9 <phase_5+0x77>        // if = 0, aka equal,jump
4010c6:   e8 6f 03 00 00          call   40143a <explode_bomb>        
4010cb:   0f 1f 44 00 00          nopl   0x0(%rax,%rax,1)
4010d0:   eb 07                   jmp    4010d9 <phase_5+0x77>
4010d2:   b8 00 00 00 00          mov    $0x0,%eax                    // reset eax to 0
4010d7:   eb b2                   jmp    40108b <phase_5+0x29>        
4010d9:   48 8b 44 24 18          mov    0x18(%rsp),%rax              // move value at stack top + 24 offset to rax 
4010de:   64 48 33 04 25 28 00    xor    %fs:0x28,%rax                // xor canery with value at stack top + 24 offset. If = 0 means they are the same, means canery is untouched, aka no buffer overlow *******
4010e5:   00 00
4010e7:   74 05                   je     4010ee <phase_5+0x8c>        // equals 0 so jump
4010e9:   e8 42 fa ff ff          call   400b30 <__stack_chk_fail@plt>// otherwise call stack fail
4010ee:   48 83 c4 20             add    $0x20,%rsp                   // deallocate stack
4010f2:   5b                      pop    %rbx                         // pop back original rbx val 
4010f3:   c3                      ret


/*
"abcdef" = 97 - 102, and will become 1-6 after masking the last 4 bits 

"maduiersnfotvbylSo you think you can stop the bomb with ctrl-c, do you?"
      567 9   1415


9 15 14 5 6 7 
i  o  n e f g      (we know 5 = e, then we just keep counting alphabets)


j = 10
k = 11
l = 12
m = 13
n = 14

one possible answer = "ionefg"
*/
