
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

; answer = 1 2 4 8 16 32




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






00000000004010f4 <phase_6>:
4010f4:	41 56                	push   %r14
4010f6:	41 55                	push   %r13
4010f8:	41 54                	push   %r12
4010fa:	55                   	push   %rbp
4010fb:	53                   	push   %rbx
4010fc:	48 83 ec 50          	sub    $0x50,%rsp               // allocate 80 bytes on stack
401100:	49 89 e5             	mov    %rsp,%r13                // mov %rsp = move the pointer to r13. mov (%rsp) = dereferencing the pointer and move the val
401103:	48 89 e6             	mov    %rsp,%rsi                
401106:	e8 51 03 00 00       	call   40145c <read_six_numbers>
40110b:	49 89 e6             	mov    %rsp,%r14                // now rsp pointing to the 1st num
40110e:	41 bc 00 00 00 00    	mov    $0x0,%r12d               



// outer loop

401114:	4c 89 ed             	mov    %r13,%rbp                // update rbp to r13
401117:	41 8b 45 00          	mov    0x0(%r13),%eax           // dereferencing val at r13 to rax, it starts at 1st num
40111b:	83 e8 01             	sub    $0x1,%eax                
40111e:	83 f8 05             	cmp    $0x5,%eax                
401121:	76 05                	jbe    401128 <phase_6+0x34>    // num - 1 <= 5, aka num <= 6
401123:	e8 12 03 00 00       	call   40143a <explode_bomb> 
401128:	41 83 c4 01          	add    $0x1,%r12d               // increment i starting from 0
40112c:	41 83 fc 06          	cmp    $0x6,%r12d               // while (i < 6)
401130:	74 21                	je     401153 <phase_6+0x5f>
401132:	44 89 e3             	mov    %r12d,%ebx               // ebx = i

// a nested loop

// loop to check if all nums after are different than the previous num
// e.g.
// loop to check if 2nd - 6th num are different than 1st num
// loop to check if 3rd - 6th num are different than 2nd num
// loop to check if 4th - 6th num are different than 3rd num ...

for (int i = 0; i <= 6; i++)
{
	if (num[i] > 6) bomb;
	for (int j = i + 1; j <= 6; j++)
	{
		if (num[i] == num[j]) bomb;
	}

}

401135:	48 63 c3             	movslq %ebx,%rax               
401138:	8b 04 84             	mov    (%rsp,%rax,4),%eax       
40113b:	39 45 00             	cmp    %eax,0x0(%rbp)
40113e:	75 05                	jne    401145 <phase_6+0x51>
401140:	e8 f5 02 00 00       	call   40143a <explode_bomb>
401145:	83 c3 01             	add    $0x1,%ebx                 
401148:	83 fb 05             	cmp    $0x5,%ebx
40114b:	7e e8                	jle    401135 <phase_6+0x41>
40114d:	49 83 c5 04          	add    $0x4,%r13                // r13 point to next num
401151:	eb c1                	jmp    401114 <phase_6+0x20>    



401153:	48 8d 74 24 18       	lea    0x18(%rsp),%rsi          // move pointer at rsp + 24 offset to %rsi
401158:	4c 89 f0             	mov    %r14,%rax                // move pointer at rsp + 0 to %rax
40115b:	b9 07 00 00 00       	mov    $0x7,%ecx                 

// a loop to reverse the 6 numbers
for (int i = 0; i <= 6; i++)
{
	num[i] = 7 - num[i];
}
                                                                // 1st loop:             // 2nd loop:
401160:	89 ca                	mov    %ecx,%edx                // edx = 7               // edx = 7 
401162:	2b 10                	sub    (%rax),%edx              // edx = 7 - 1 = 6       // edx = 7 - 2 = 5
401164:	89 10                	mov    %edx,(%rax)              // 1st num = 6           // 2nd num = 5
401166:	48 83 c0 04          	add    $0x4,%rax                // point to next num     
40116a:	48 39 f0             	cmp    %rsi,%rax                // while num 1 <= num 6
40116d:	75 f1                	jne    401160 <phase_6+0x6c>



40116f:	be 00 00 00 00       	mov    $0x0,%esi                
401174:	eb 21                	jmp    401197 <phase_6+0xa3>


// outer loop

// nested loop
// traverse linked-list
401176:	48 8b 52 08          	mov    0x8(%rdx),%rdx           // ********** 
                                                                // very interesting
								// for the first increment:
								// be careful it is not lea 0x8(%rdx)
								// which = 0x6032d8
								// but here we have mov 0x8(%rdx)
								// which means we deference the val at 0x6032d8
								// which is a 0x6032e0, interesting!
								// we see that  address 0x6032d8 stores a 
								// pointer pointing at 0x6032e0
                                                                // so rdx = 0x6032e0

40117a:	83 c0 01             	add    $0x1,%eax                // eax = 2
40117d:	39 c8                	cmp    %ecx,%eax                // 2 != 6
40117f:	75 f5                	jne    401176 <phase_6+0x82>

using x /30w 0x6032d0, we see the up coming 30 addresses since 0x6032d0

                  (sercet num) (our input) (next pointer)
0x6032d0 <node1>:   0x0000014c 0x00000001 0x006032e0
0x6032e0 <node2>:   0x000000a8 0x00000002 0x006032f0
0x6032f0 <node3>:   0x0000039c 0x00000003 0x00603300
0x603300 <node4>:   0x000002b3 0x00000004 0x00603310
0x603310 <node5>:   0x000001dd 0x00000005 0x00603320
0x603320 <node5>:   0x000001bb 0x00000006 0x00000000 (nullptr)

14c = 332
a8  = 168
39c = 924
2b3 = 691
1dd = 477
1bb = 443

// nested loop end ***

// placing node on stack
401181:	eb 05                	jmp    401188 <phase_6+0x94>
401183:	ba d0 32 60 00       	mov    $0x6032d0,%edx
401188:	48 89 54 74 20       	mov    %rdx,0x20(%rsp,%rsi,2)   // 6th node at stack top + 32 offset
                                                                // 5th node at stack top + 40 offset
								// 4th node at stack top + 48 offset

40118d:	48 83 c6 04          	add    $0x4,%rsi                // increment offset
401191:	48 83 fe 18          	cmp    $0x18,%rsi               // 4 != 24         // 8 != 24 ...
401195:	74 14                	je     4011ab <phase_6+0xb7>    
401197:	8b 0c 34             	mov    (%rsp,%rsi,1),%ecx       // ecx = 1st num   // ecx = 2nd num ...
40119a:	83 f9 01             	cmp    $0x1,%ecx                
40119d:	7e e4                	jle    401183 <phase_6+0x8f>   
40119f:	b8 01 00 00 00       	mov    $0x1,%eax                // eax = 1
4011a4:	ba d0 32 60 00       	mov    $0x6032d0,%edx           // edx = 0x6032d0 
4011a9:	eb cb                	jmp    401176 <phase_6+0x82>    


4011ab:	48 8b 5c 24 20       	mov    0x20(%rsp),%rbx          // rbx = 0x603320
4011b0:	48 8d 44 24 28       	lea    0x28(%rsp),%rax          // rax = rsp + 40
4011b5:	48 8d 74 24 50       	lea    0x50(%rsp),%rsi          // rsi = rsp + 80
4011ba:	48 89 d9             	mov    %rbx,%rcx                // rcx = 0x603320

// reverse linked-list **********
4011bd:	48 8b 10             	mov    (%rax),%rdx              // rdx = 0x603310   // = 0x603300 ...
4011c0:	48 89 51 08          	mov    %rdx,0x8(%rcx)           // 0x603328 = 0x603310 instead of nullptr  // 0x603318 = 0x603300 ...
4011c4:	48 83 c0 08          	add    $0x8,%rax                // rax = rsp + 48   // rax = rsp + 56 ...
4011c8:	48 39 f0             	cmp    %rsi,%rax                // rsp + 48 != rsp + 80  
4011cb:	74 05                	je     4011d2 <phase_6+0xde>
4011cd:	48 89 d1             	mov    %rdx,%rcx                // rcx = 0x603310  // rcx = 0x603300 ...
4011d0:	eb eb                	jmp    4011bd <phase_6+0xc9>

4011d2:	48 c7 42 08 00 00 00 	movq   $0x0,0x8(%rdx)           // set nullptr

                  (sercet num) (our input) (next pointer)
0x6032d0 <node1>:   0x0000014c 0x00000001 0x00000000 (nullptr)
0x6032e0 <node2>:   0x000000a8 0x00000002 0x006032d0
0x6032f0 <node3>:   0x0000039c 0x00000003 0x006032e0
0x603300 <node4>:   0x000002b3 0x00000004 0x006032f0
0x603310 <node5>:   0x000001dd 0x00000005 0x00603300
0x603320 <node6>:   0x000001bb 0x00000006 0x00603310

14c = 332, a8 = 168, 39c = 924, 2b3 = 691, 1dd = 477, 1bb = 443

4011d9:	00 
4011da:	bd 05 00 00 00       	mov    $0x5,%ebp                // ebp = 5
4011df:	48 8b 43 08          	mov    0x8(%rbx),%rax           // rax = dereferencing 0x603328 and got another pointer = 0x603310
4011e3:	8b 00                	mov    (%rax),%eax              // eax = dereferencing 0x603310 = 1dd
4011e5:	39 03                	cmp    %eax,(%rbx)              // cmp %eax's 1dd to (%rbx)'s 1bb, aka 477 vs 443 
4011e7:	7d 05                	jge    4011ee <phase_6+0xfa>    // jump if (rbx) >= eax, but we bomb bc 1bb is not >= 1dd
4011e9:	e8 4c 02 00 00       	call   40143a <explode_bomb>    // so probably something went wrong at the very beg.
                                                               

**************************************************************************************************************************************************
// if we try to input our 6 nums as 6 5 4 3 2 1, then it will reverse to (rsp) = 1, (rsp + 4) = 2, (rsp + 8) = 3...
// it also means that we have (rsp + 32) = 0x6032d0, ...  (rsp + 80) = 0x603320
// p /x *(int *)($rsp + 32) to get 0x6032d0
// p /x *(0x6032d8) to get 0x6032e0
// p /x *(0x603328) to get nullptr 
// and we can conclude:

0x603320 <node6>:   0x000001bb 0x00000006 0x00000000 (nullptr)
0x603310 <node5>:   0x000001dd 0x00000005 0x00603320
0x603300 <node4>:   0x000002b3 0x00000004 0x00603310
0x6032f0 <node3>:   0x0000039c 0x00000003 0x00603300
0x6032e0 <node2>:   0x000000a8 0x00000002 0x006032f0
0x6032d0 <node1>:   0x0000014c 0x00000001 0x006032e0 

then we will have eax = 168, (rbx) = 332, and  we won't bomb


but during the 2nd loop
we will haveto compare eax = 39c (924) to (rbx) = a8 (168) it will bomb again.


so we need to have pointer that point to the biggest number at rsp + 32 and smallest at rsp + 80
so we want node3 => node4 => node5 => node6 => node1 => node2

but remember to get node1, 2, 3, 4, 5, 6,
we need to input 6, 5, 4, 3, 2, 1
which is 7-6=1, 7-5=2, 7-4=3, 7-4=3, 7-3=2, 7-2=1

so if we want 3, 4, 5, 6, 1, 2
then we will input 7-3=4, 7-4=3, 7-5=2, 7-6=1, 7-1=6, 7-2=5

and the correct linked-list is 
0x6032e0 <node2>:   0x000000a8 0x00000002 0x00000000 (nullptr)
0x6032d0 <node1>:   0x0000014c 0x00000001 0x006032e0 
0x603320 <node6>:   0x000001bb 0x00000006 0x006032d0 
0x603310 <node5>:   0x000001dd 0x00000005 0x00603320
0x603300 <node4>:   0x000002b3 0x00000004 0x00603310
0x6032f0 <node3>:   0x0000039c 0x00000003 0x00603300


**************************************************************************************************************************************************

4011ee:	48 8b 5b 08          	mov    0x8(%rbx),%rbx          
4011f2:	83 ed 01             	sub    $0x1,%ebp
4011f5:	75 e8                	jne    4011df <phase_6+0xeb>
4011f7:	48 83 c4 50          	add    $0x50,%rsp
4011fb:	5b                   	pop    %rbx
4011fc:	5d                   	pop    %rbp
4011fd:	41 5c                	pop    %r12
4011ff:	41 5d                	pop    %r13
401201:	41 5e                	pop    %r14
401203:	c3                   	ret    

// ans = 4 3 2 1 6 5 
