
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
// loop starts
  400f17:	8b 43 fc             	mov    -0x4(%rbx),%eax            // move the val before rbx to eax
                                                                          // we can see each val is 4 byte,
				                                          // so it is int
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
// loop finish 

  400f30:	48 8d 5c 24 04       	lea    0x4(%rsp),%rbx             // stack top pointer + 4 bytes to rbx
  400f35:	48 8d 6c 24 18       	lea    0x18(%rsp),%rbp            // stack top pointer + 24 bytes to rbp
                                                                          // we can see we are initailizing vals
						                          // for potential loop
														
  400f3a:	eb db                	jmp    400f17 <phase_2+0x1b>      
  400f3c:	48 83 c4 28          	add    $0x28,%rsp                 // deallocate the stack
  400f40:	5b                   	pop    %rbx                       // pop back the value in memory stack back to the registers
  400f41:	5d                   	pop    %rbp
  400f42:	c3                   	ret    



phase 5

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
